require 'sinatra'
require "sinatra/cross_origin"
require 'byebug'
require 'date'
require 'rest-client'
require 'json'
configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

def endpoint_call(base, month)
  begin
    # url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{params[:base_year]}/#{params[:current_month]}/"
    # print url
    url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{base}/#{month}"
    response = RestClient.get url
    print intermediary_response = JSON.parse(response)
    # puts pretty_response = JSON.pretty_generate(intermediary_response)
    puts "#" * 10
    print intermediary_response.keys
    base_index = intermediary_response["index"]["MS_HLTH_IDX"]
    puts "#" * 10
    return base_index
  rescue RestClient::ExceptionWithResponse => e
    p e.response
  end
end

def removing_month(date_object)
  date_year = date_object.year
  date_mon = date_object.mon
  date_day = date_object.day
  if date_mon == 1
    date_mon = 12
    date_year -= 1
  else
    date_mon -= 1
  end
  Date.new(date_year, date_mon, date_day)
end

# ROUTES ...
post '/v1/indexations' do
  data = JSON.parse request.body.read
  print data
  signed_on = Date.parse(data["signed"])
  signed_on = removing_month(signed_on)
  base_month = signed_on.strftime("%Y-%m")
  puts "Base Month : #{base_month}"

  start_on = Date.parse(data["start"])
  start_month = start_on.mon
  start_day = start_on.day

  present_year = Date.today.year
  recent_birthday = Date.new(present_year, start_month, start_day)
  today = Date.today

  if today > recent_birthday

    recent_birthday = removing_month(recent_birthday)
    current_month = recent_birthday.strftime("%Y-%m")
  else
    recent_month = recent_birthday.month - 1
    recent_day = recent_birthday.day
    recent_year = Date.today.year - 1
    current_month = Date.new(recent_year, recent_month, recent_day).strftime("%Y-%m")
  end
  puts "Current Month : #{current_month}"

  bases = [1988, 1996, 2004, 2013]

  year_selected = nil
  bases.map do |year|
    if year <= Date.parse(data["signed"]).year
      year_selected = year
    end
  end
  p "#{year_selected}"

  rent = data["rent"]
  region = data["region"]
  params = {
    base_year: year_selected,
    region: data["region"],
    rent: data["rent"],
    base_month: base_month,
    current_month: current_month
  }

  indexes = {}


  indexes[:current] = endpoint_call(params[:base_year], params[:current_month])
  indexes[:base] = endpoint_call(params[:base_year], params[:base_month])

  # Computing the rent

  new_rent = (params[:rent].to_i * indexes[:current].to_f) / indexes[:base].to_f
  puts "RENT : #{new_rent} "
  {
    new_rent: new_rent.round(2),
    base_index: indexes[:base],
    current_index: indexes[:current]
  }.to_json
end

options '*' do
  response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end
