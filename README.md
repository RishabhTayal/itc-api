# itc-api

[![Build Status](https://travis-ci.org/RishabhTayal/itc-api.svg?branch=master)](https://travis-ci.org/RishabhTayal/itc-api)
[![License](https://img.shields.io/badge/license-MIT-999999.svg)](https://github.com/RishabhTayal/ReviewMonitor/blob/master/LICENSE)
[![Contact](https://img.shields.io/badge/contact-%40Rishabh_Tayal-3a8fc1.svg)](https://twitter.com/Rishabh_Tayal)

Backend API project for [ReviewMonitor](https://github.com/RishabhTayal/ReviewMonitor/) iOS app.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api)

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
