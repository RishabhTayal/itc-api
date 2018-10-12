require 'sinatra'
require 'spaceship'
require 'json'
require './version_api.rb'
require './testflight.rb'
require './appstore.rb'

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

  app = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  live_version = app.live_version
  hash_map[:live_version] = live_version.version unless live_version.nil?

  edit_version = app.edit_version
  hash_map[:edit_version] = edit_version.version unless edit_version.nil?

  details = app.details
  hash_map[:primarycat] = details.primary_category
  hash_map[:primarycatfirstsub] = details.primary_first_sub_category
  hash_map[:primarycatsecondsub] = details.primary_second_sub_category
  hash_map[:secondarycat] = details.secondary_category
  hash_map[:secondarycatfirstsub] = details.secondary_first_sub_category
  hash_map[:secondarycatsecondsub] = details.secondary_second_sub_category
  hash_map.to_json
end

# Get metadata for the live version of the app
get '/app/live_version_metadata' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  Spaceship::Tunes.login(username, password)

  app = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  # if there is a live_version of the app
  live_version = app.live_version
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

    screenshots = []
    live_version.screenshots['en-US'].each do |screenshot|
      p screenshot
      screenshot_hash = Hash.new([])
      screenshot_hash[:original_file_name] = screenshot.original_file_name
      screenshot_hash[:url] = screenshot.url
      screenshots.push(screenshot_hash)
    end
    hash_map[:screenshots] = screenshots
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

  app = Spaceship::Tunes::Application.find(bundle_id)
  hash_map = Hash.new([])

  # if there is a edit_version of the app
  edit_version = app.edit_version
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

# Returns builds submitted for the app
get '/build_trains' do
  content_type :json
  username = request.env['HTTP_USERNAME']
  password = request.env['HTTP_PASSWORD']
  bundle_id = params[:bundle_id]
  Spaceship::Tunes.login(username, password)

  app = Spaceship::Tunes::Application.find(bundle_id)
  train = app.build_trains

  hash_map = Hash.new([])
  hash_map[:versions] = train.versions
  hash_map.to_json
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
