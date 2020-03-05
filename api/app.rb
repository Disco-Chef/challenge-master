require 'sinatra'
require "sinatra/cross_origin"
require 'open-uri'
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

# ROUTES ...

post '/v1/indexations' do
  data = JSON.parse request.body.read
  print data
  p signed_on = Date.parse(data["signed"])
  sign_month = signed_on.mon

  if signed_on.mon == 1
    sign_month = 12
    sign_year = signed_on.year - 1
  else
    sign_month = signed_on.mon - 1
    sign_year = signed_on.year
  end

  sign_day = signed_on.day
  signed_on = Date.new(sign_year, sign_month, sign_day)
  base_month = signed_on.strftime("%Y-%m")
  puts "Base Month : #{base_month}"

  start_on = Date.parse(data["start"])
  start_month = start_on.mon
  start_day = start_on.day

  test_year = Date.today.year
  test_birthday = Date.new(test_year, start_month, start_day)
  today = Date.today

  if today > test_birthday
    current_month = test_birthday.strftime("%Y-%m")
  else
    test_year = Date.today.year - 1
    current_month = Date.new(test_year, start_month, start_day).strftime("%Y-%m")
  end
  puts "Current Month : #{current_month}"

  bases = [2013, 2004, 1996, 1988]

  year_selected = bases.map do |year|
    year if year <= signed_on.year
  end.max

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

  p params[:base_month]

  begin
    # url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{params[:base_year]}/#{params[:current_month]}/"
    # print url
    print "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{params[:base_year]}/#{params[:base_month]}"
    response = RestClient.get "https://fi7661d6o4.monthexecute-api.eu-central-1.amazonaws.com/prod/indexes/#{params[:base_year]}/#{params[:base_month]}"
    print intermediary_response = JSON.parse(response)
    # puts pretty_response = JSON.pretty_generate(intermediary_response)
    puts "#"*10
    print intermediary_response.keys
    base_index = intermediary_response['index']["MS_HLTH_IDX"]
    puts "#"*10
    print base_index
  rescue RestClient::ExceptionWithResponse => e
    p e.response
  end

  # begin
  #   url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{params["base_year"]}/#{params["current_month"]}"
  #   puts url
  #   response_two = RestClient.get(url)
  #   intermediary_response_two = JSON.parse(response_two)
  #   current_index = intermediary_response_two["index"]["MS_HLTH_IDX"]
  #   # puts JSON.pretty_generate response
  #   p current_index
  # rescue RestClient::ExceptionWithResponse => e
  #   p e.response
  # end
end

options '*' do
  response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end
