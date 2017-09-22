require 'sinatra'
require 'spaceship'
require 'json'

# Login user
post '/login' do
	content_type :json
	username = params[:username]
	password = params[:password]
	Spaceship::Tunes.login(username, password)
	app = Spaceship::Tunes::Application.all[0]
	return { success: true }.to_json
end

# Get list of apps
get '/apps' do
	content_type :json
	username = params[:username]
	password = params[:password]
	Spaceship::Tunes.login(username, password)
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
	Spaceship::Tunes.login(username, password)
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
	Spaceship::Tunes.login(username, password)
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
	Spaceship::Tunes.login(username, password)
	app = Spaceship::Tunes::Application.find(bundle_id)
	body app.ratings.deleteResponse(rating_id, response_id).to_json
end