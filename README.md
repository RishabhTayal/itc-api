# itc-api

Backend API project for [ReviewMonitor](https://github.com/RishabhTayal/ReviewMonitor/) iOS app.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api/tree/master)

# Installation

### Prerequisites

Make sure you have [bundler](http://bundler.io) installed. Otherwise install it with following command
``` gem install bundler ```
Ruby 2.4.0 +

### Installing

Clone the repo ``` git clone https://github.com/RishabhTayal/itc-api.git ```
To install all dependencies run  ``` bundle install ```
If this is done run:  ``` ruby server.rb ```

That's all, to stop press Ctrl + C

# Update to a new version

From time to time there will be updates to `itc-api`. There are 2 ways to update your Heroku application:

### Recommended: Using the terminal

- Install the [Heroku toolbelt](https://toolbelt.heroku.com/) and `heroku login`
- Clone your application using `heroku git:clone --app [heroku_app_name]` (it will be an empty repo)
- `cd [heroku_app_name]`
- `git pull https://github.com/RishabhTayal/itc-api`
- `git push`

### Using Heroku website

- Delete your application on [heroku.com](https://www.heroku.com/)
- [Create a new itc-api application](https://www.heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api)

# Troubleshooting
 - RVM used your Gemfile for selecting Ruby... -> This is only a warning skip it or run ``` rvm rvmrc warning ignore allGemfiles ```
 
 - Error on run: undefined... <main>:... -> Run  ``` bundle install ```  and check if there are no errors
 
# Contributing to the app

Want to see something implemented in the app? We are always looking for some contributors who can help with some more features. Create an [issue](https://github.com/RishabhTayal/ReviewMonitor/issues/new) or [PR](https://github.com/RishabhTayal/ReviewMonitor/compare) if you are interested. Want to get involved in discussions? Join our [Slack channel](https://itc-manager-slack-invite.herokuapp.com)
