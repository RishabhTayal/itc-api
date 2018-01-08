require 'sinatra'
require 'spaceship'
require 'json'

# Get List of testers
get '/testers' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]

  Spaceship::Tunes.login(username, password)
  client = Spaceship::Tunes.client
  client.team_id = request.env['HTTP_TEAM_ID']
  apps = Spaceship::Tunes::Application.all
  myapp = apps.select { |a| a.bundle_id.casecmp(bundle_id).zero?   }
  testers = Spaceship::TestFlight::Tester.all(app_id: myapp.first.apple_id)
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

  Spaceship::Tunes.login(username, password)
  client = Spaceship::Tunes.client
  client.team_id = request.env['HTTP_TEAM_ID']

  Spaceship::TestFlight::Tester.create_app_level_tester(
    app_id: bundle_id,
    email: email,
    first_name: first_name,
    last_name: last_name
  )
end
