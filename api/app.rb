require 'sinatra'
require 'sinatra/cross_origin'
configure do
  enable :cross_origin
end

before do
  response.headers["Access-Control-Allow-Origin"] = "*"
end

# ROUTES ...
get '/v1/indexations' do
  "Hello World"
end
 post '/v1/indexations' do
  data = JSON.parse request.body.read
  print data
  { data: "Hello #{data['name']}!" }.to_json
end

options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

