source 'https://rubygems.org'

# ruby '2.4.0'

gem 'sinatra'

# gemspec path: File.expand_path("/Users/rtayal/Desktop/Forks/fastlane")
gem 'danger'
gem 'fastlane', git: 'https://github.com/RishabhTayal/fastlane.git', branch: 'spaceship-review-response-methods'
gem 'pry'
gem 'puma'
gem 'rubocop', '~> 0.49.1'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
