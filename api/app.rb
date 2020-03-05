require 'sinatra'
require 'sinatra/cross_origin'
require 'open-uri'
require 'byebug'
require 'date'
configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# ROUTES ...

 post '/v1/indexations' do
  data = JSON.parse request.body.read

  signed_on = Date.parse(data.signed)
  signed_on = signed_on - 31
  base_month = signed_on.strftime("%Y-%m")

  start_on = Date.parse(data.start)
  testy = Date.parse(start_on.strftime("%d-%m-") + Date.today.year)
  testy = Date.parse(start_on.strftime("%d-%m-") + (Date.today.year - 1)) if testy > Date.today

  current_month = testy.strftime("%Y-%m")

  bases = [2013, 2004, 1996, 1988]

  bases.each do |year|
    return base_year = year if year <= signed_on.year
  end

  rent = data.rent
  region = data.region
  print call_endpoint(base_year, base_month)
end

options '*' do
  response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end

def call_endpoint(base, base_month)
  url = "https://fi7661d6o4.execute-api.eu-central-1.amazonaws.com/prod/indexes/#{base}/#{base_month}"
  index_doc = open(url)
  return index_doc
  # byebug
end
