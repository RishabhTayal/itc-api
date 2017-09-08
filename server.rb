require 'sinatra'
require 'spaceship'
require 'json'

# Get list of apps
get '/apps' do
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	all_apps = Spaceship::Tunes::Application.all
	all_apps = all_apps.sort { |x, y|
		x.name <=> y.name
	}
	all_apps.collect { |a|
		{
			name: a.name,
			bundle_id: a.bundle_id,
			app_icon_preview_url: a.app_icon_preview_url
		}
	}.to_json
end

# Get list of ratings for a specified app with bundle_id
get '/ratings' do
	bundle_id = params[:bundle_id]
	store_front = params[:store_front]
	if store_front == nil 
		store_front = ""
	end
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
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
	rating_id = params[:rating_id]
	bundle_id = params[:bundle_id]
	response = params[:response_text]
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	app = Spaceship::Tunes::Application.find(bundle_id)
	body app.ratings.sendResponse(rating_id, response).to_json
end