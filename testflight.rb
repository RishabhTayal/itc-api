require 'sinatra'
require 'spaceship'
require 'json'

# Get List of testers
get '/testers' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  puts bundle_id
  client = Spaceship::TunesClient.new
  client.login(username, password)
  client.team_id = request.env['HTTP_TEAM_ID']
  # Spaceship::Tunes.client.team_id = params[:team_id]
  # Spaceship::Portal.login(username, password)
  # Spaceship::Portal.client.team_id = params[:team_id]
  # puts client.team_id
  apps = client.applications.find(bundle_id)
  p app.to_json
  testers = Spaceship::TestFlight::Tester.all(app_id: apps.first['adamId'])
  testers.collect do |tester|
    {
      first_name: tester.first_name,
      last_name: tester.last_name,
      email: tester.email
    }
  end.to_json
end

# Creating new testers
post '/tester' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  email = params[:email]
  first_name = params[:first_name]
  last_name = params[:last_name]

  client = Spaceship::TunesClient.new
  client.login(username, password)
  client.team_id = request.env['HTTP_TEAM_ID']

  Spaceship::TestFlight::Tester.create_app_level_tester(
    app_id: bundle_id,
    email: email,
    first_name: first_name,
    last_name: last_name
  )
end
