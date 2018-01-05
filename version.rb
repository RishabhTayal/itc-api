require 'sinatra'
require 'json'
require 'net/http'

get '/is_latest_api_version' do
  content_type :json
  version = '1.0'

  uri = URI('https://api.github.com/repos/RishabhTayal/itc-api/releases/latest')
  response = Net::HTTP.get(uri)
  JSON.parse(response)
  puts response
  # return { version: "1.0" }.to_json
end
