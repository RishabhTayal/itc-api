require 'sinatra'
require 'spaceship'
require 'json'

# Login user
post '/login' do
	content_type :json
	username = params[:username]
	password = params[:password]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.teams.to_json
end

# Get list of apps
get '/apps' do
	content_type :json
	username = params[:username]
	password = params[:password]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	all_apps = Spaceship::Tunes::Application.all
	live_apps = all_apps.select { |app|
		# app.live_version != nil
		app.app_icon_preview_url != nil
	}
	live_apps = live_apps.sort { |x, y|
		x.name <=> y.name
	}
	live_apps.collect { |a|
		{
			name: a.name,
			bundle_id: a.bundle_id,
			app_icon_preview_url: a.app_icon_preview_url
		}
	}.to_json
end

# Get list of ratings for a specified app with bundle_id
get '/ratings' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	store_front = params[:store_front]
	if store_front == nil 
		store_front = ""
	end
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	ratings = Spaceship::Tunes::Application.find(bundle_id).ratings
	ratings.reviews(store_front).collect { |review|
		{
			id: review.id,
			title: review.title,
			rating: review.rating,
			review: review.review,
			store_front: review.store_front,
			total_views: review.total_views,
			raw_developer_response: review.raw_developer_response,
			developer_response: {
				id: review.developer_response.id,
				response: review.developer_response.response,
				last_modified: review.developer_response.last_modified,
				hidden: review.developer_response.hidden,
      			state: review.developer_response.state
			}
		}
	}.to_json
end

# Add a new response to a rating
post '/response' do
	content_type :json
	username = params[:username]
	password = params[:password]
	rating_id = params[:rating_id]
	bundle_id = params[:bundle_id]
	response = params[:response_text]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	app = Spaceship::Tunes::Application.find(bundle_id)
	body app.ratings.sendResponse(rating_id, response).to_json
end

# Delete developer response from a review
delete '/response' do
	content_type :json
	username = params[:username]
	password = params[:password]
	rating_id = params[:rating_id]
	bundle_id = params[:bundle_id]
	response_id = params[:response_id]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	app = Spaceship::Tunes::Application.find(bundle_id)
	body app.ratings.deleteResponse(rating_id, response_id).to_json
end

get '/app_status' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	app = Spaceship::Tunes::Application.find(bundle_id)
	app.edit_version.to_json
end

# Get List of testers
get '/testers' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	CredentialsManager::PasswordManager.logout
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.team_id = params[:team_id]
	Spaceship::Portal.login(username, password)
	Spaceship::Portal.client.team_id = params[:team_id]
	puts Spaceship::Tunes.client.team_id
	app = Spaceship::Tunes::Application.find(bundle_id)
	testers = Spaceship::TestFlight::Tester.all(app_id: app.apple_id)
	testers.collect { |tester|
		{
			first_name: tester.first_name,
			last_name: tester.last_name,
			email: tester.email
		}
	}.to_json
end