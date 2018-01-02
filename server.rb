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

post '/login/v2' do
	content_type :json
	username = params[:username]
	password = params[:password]
	Spaceship::Tunes.login(username, password)
	Spaceship::Tunes.client.teams.to_json
end

# Get list of apps

get '/app/metadata' do
    content_type :json
    username = params[:username]
    password = params[:password]
    bundle_id = params[:bundle_id]
    client = Spaceship::Tunes.login(username, password)
    client.team_id = params[:team_id]
    
    app = Spaceship::Tunes::Application.find(bundle_id)
    
    version = app.live_version.version
    copyright = app.live_version.copyright
    status = app.live_version.app_status
    live = app.live_version.is_live
    primcat = app.details.primary_category
    firstsubcat = app.details.primary_first_sub_category
    secondsubcat = app.details.primary_second_sub_category
    
    seccat = app.details.secondary_category
    firstsubseccat = app.details.secondary_first_sub_category
    secondsubseccat = app.details.secondary_second_sub_category

    watch = app.live_version.supports_apple_watch

    arr = ["version": version, "copyright": copyright, "status": status, "live": live, "prim_categ": primcat, "prim_sub_categ": firstsubcat, "second_sub_categ": secondsubcat, "sec_categ": seccat, "sec_sub_categ": firstsubseccat, "sec_second_sub_categ": secondsubseccat, "applewatch": watch].to_json
end

get '/apps' do
	content_type :json
	username = params[:username]
	password = params[:password]
	client = Spaceship::Tunes.login(username, password)
	client.team_id = params[:team_id]
	all_apps = Spaceship::Tunes::Application.all
	# live_apps = all_apps.select { |app|
	# 	# app.live_version != nil
	# 	app.app_icon_preview_url != nil
	# }
	all_apps = all_apps.sort { |x, y|
		x.name <=> y.name
	}
	all_apps.collect { |a|
		{
			name: a.name,
			bundle_id: a.bundle_id,
			apple_id: a.apple_id,
			app_icon_preview_url: a.app_icon_preview_url,
			platforms: a.platforms
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
			last_modified: review.last_modified,
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

# Returns 
get '/build_trains' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	Spaceship::Tunes.login(username, password)
	# require "pry"
	# binding.pry
	app = Spaceship::Tunes::Application.find(bundle_id)
	train = app.build_trains
	puts train
	train.to_json
end

# Returns list of all processing builds from iTC
get '/processing_builds' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	Spaceship::Tunes.login(username, password)
	app = Spaceship::Tunes::Application.find(bundle_id)
	# require "pry"
	# binding.pry
	app.all_processing_builds.to_json
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

get '/app_status' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	Spaceship::Tunes.login(username, password)
	app = Spaceship::Tunes::Application.find(bundle_id)
	app.edit_version.to_json
end

# Get List of testers
get '/testers' do
	content_type :json
	username = params[:username]
	password = params[:password]
	bundle_id = params[:bundle_id]
	puts bundle_id
	client = Spaceship::TunesClient.new
	client.login(username, password)
	client.team_id = params[:team_id]
	# Spaceship::Tunes.client.team_id = params[:team_id]
	# Spaceship::Portal.login(username, password)
	# Spaceship::Portal.client.team_id = params[:team_id]
	# puts client.team_id
	apps = client.applications.find(bundle_id)
	# p app.to_json
	for app in apps
		p app.to_json
	end
	testers = Spaceship::TestFlight::Tester.all(app_id: apps.first["adamId"])
	testers.collect { |tester|
		{
			first_name: tester.first_name,
			last_name: tester.last_name,
			email: tester.email
		}
	}.to_json
end
