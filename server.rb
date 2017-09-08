require 'sinatra'
require 'spaceship'
require 'json'

get '/' do
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	all_apps = Spaceship::Tunes::Application.all
	all_apps.collect { |a|
		{
			name: a.name,
			bundle_id: a.bundle_id,
			app_icon_preview_url: a.app_icon_preview_url
		}
	}.to_json
end

get '/ratings' do
	bundle_id = params[:bundle_id]
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	ratings = Spaceship::Tunes::Application.find(bundle_id).ratings
	ratings.reviews("US").collect { |review|
		{
			title: review.title,
			review: review.review,
			total_views: review.total_views,
			raw_developer_response: review.raw_developer_response,
			developer_response: review.developer_response
		}
	}.to_json
end

post '/response' do
	rating_id = params[:rating_id]
	bundle_id = params[:bundle_id]
	response = params[:response_text]
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	app = Spaceship::Tunes::Application.find(bundle_id)
	body app.ratings.sendResponse(rating_id, response).to_json
	# body app.ratings.average_ratin.to_json
end