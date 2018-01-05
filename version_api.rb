require 'sinatra'
require 'json'
require 'net/http'

get '/is_latest_api_version' do
  content_type :json
  file = File.read('version.json')
  version_json = JSON.parse(file)
  version = version_json['version']

  uri = URI('https://api.github.com/repos/RishabhTayal/itc-api/releases/latest')
  response = Net::HTTP.get(uri)
  json = JSON.parse(response)
  tag_name = json['tag_name']

  (tag_name == version).to_json

end
