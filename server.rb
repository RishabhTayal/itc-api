require 'sinatra'
require 'spaceship'
require 'json'

get '/' do
  content_type :json
  return { itc_api: true }.to_json
end

# Login user
post '/login' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  Spaceship::Tunes.login(username, password)
  Spaceship::Tunes::Application.all[0]
  return { success: true }.to_json
end

post '/login/v2' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  Spaceship::Tunes.login(username, password)
  Spaceship::Tunes.client.teams.to_json
end

# Get list of apps
get '/apps' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  client = Spaceship::Tunes.login(username, password)
  client.team_id = request.env['HTTP_TEAM_ID']
  all_apps = Spaceship::Tunes::Application.all
  all_apps = all_apps.sort_by(&:name)
  all_apps.collect do |a|
    {
      name: a.name,
      bundle_id: a.bundle_id,
      apple_id: a.apple_id,
      app_icon_preview_url: a.app_icon_preview_url,
      platforms: a.platforms,
      last_modified: a.last_modified
    }
  end.to_json
end

# Gets metadata of the app
get '/app/metadata' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  Spaceship::Tunes.login(username, password)

  version = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  live_version = version.live_version
  hash_map[:live_version] = live_version.version unless live_version.nil?
  edit_version = version.edit_version
  hash_map[:edit_version] = edit_version.version unless edit_version.nil?
  hash_map[:primarycat] = version.details.primary_category
  hash_map[:primarycatfirstsub] = version.details.primary_first_sub_category
  hash_map[:primarycatsecondsub] = version.details.primary_second_sub_category
  hash_map[:secondarycat] = version.details.secondary_category
  hash_map[:secondarycatfirstsub] = version.details.secondary_first_sub_category
  hash_map[:secondarycatsecondsub] = version.details.secondary_second_sub_category
  hash_map.to_json
end

# Get metadata for the live version of the app
get '/app/live_version_metadata' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  Spaceship::Tunes.login(username, password)

  version = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  # if there is a live_version of the app
  live_version = version.live_version
  unless live_version.nil?
    hash_map[:version] = live_version.version
    hash_map[:copyright] = live_version.copyright
    hash_map[:status] = live_version.app_status
    hash_map[:islive] = live_version.is_live
    hash_map[:watchos] = live_version.supports_apple_watch
    hash_map[:betaTesting] = live_version.can_beta_test
    hash_map[:lang] = live_version.languages
    hash_map[:keywords] = live_version.keywords
    hash_map[:support] = live_version.support_url
    hash_map[:marketing] = live_version.marketing_url
  end
  hash_map.to_json
end

# Get metadata for the edit version of the app
get '/app/edit_version_metadata' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  Spaceship::Tunes.login(username, password)

  version = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  # if there is a edit_version of the app
  edit_version = version.edit_version
  unless edit_version.nil?
    hash_map[:version] = edit_version.version
    hash_map[:copyright] = edit_version.copyright
    hash_map[:status] = edit_version.app_status
    hash_map[:islive] = edit_version.is_live
    hash_map[:watchos] = edit_version.supports_apple_watch
    hash_map[:betaTesting] = edit_version.can_beta_test
    hash_map[:lang] = edit_version.languages
    hash_map[:keywords] = edit_version.keywords
    hash_map[:support] = edit_version.support_url
    hash_map[:marketing] = edit_version.marketing_url
  end
  hash_map.to_json
end

# Get list of ratings for a specified app with bundle_id
get '/ratings' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  store_front = params[:store_front]
  store_front = '' if store_front.nil?
  Spaceship::Tunes.login(username, password)
  ratings = Spaceship::Tunes::Application.find(bundle_id).ratings
  ratings.reviews(store_front).collect do |review|
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
  end.to_json
end

# Returns
get '/build_trains' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
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
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
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
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
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
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  rating_id = params[:rating_id]
  bundle_id = params[:bundle_id]
  response_id = params[:response_id]
  Spaceship::Tunes.login(username, password)
  app = Spaceship::Tunes::Application.find(bundle_id)
  body app.ratings.deleteResponse(rating_id, response_id).to_json
end

get '/app_status' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  # Spaceship::Tunes.login(username, password)
  client = Spaceship::Tunes.login(username, password)
  client.team_id = request.env['HTTP_TEAM_ID']
  app = Spaceship::Tunes::Application.find(bundle_id)
  app.edit_version.to_json
end

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
  # p app.to_json
  testers = Spaceship::TestFlight::Tester.all(app_id: apps.first['adamId'])
  testers.collect do |tester|
    {
      first_name: tester.first_name,
      last_name: tester.last_name,
      email: tester.email
    }
  end.to_json
end
