require 'sinatra'
require 'json'

get '/api-version' do
	content_type :json
	return { version: "1.0" }.to_json
end