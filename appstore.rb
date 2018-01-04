require 'sinatra'
require 'spaceship'
require 'json'

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
