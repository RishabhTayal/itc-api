require 'sinatra'
require 'spaceship'
require 'json'

get '/' do
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	all_apps = Spaceship::Tunes::Application.all
	all_apps.collect { |a|
		{
			name: a.name,
		}
	}.to_json
end

get '/ratings' do
	Spaceship::Tunes.login("contact@appikon.com", "AppikonSoft121")
	ratings = Spaceship::Tunes::Application.find('com.rtayal.ChatApp').ratings
	# ratings.ratings.reviews("US").to_json
	# ratings.collect { |r|
	# 	{
	# 		reviews: r.reviews("US")
	# 	}
	# }.to_json
	ratings.reviews("US").collect { |review|
		{
			title: review.title
		}
	}.to_json
	# ratings.to_json
end