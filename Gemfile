source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'font-awesome-rails', '4.3.0.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# background Job
gem 'delayed_job_active_record'
gem "daemons"

# Cron Jobs
gem 'whenever', :require => false


# gem upload images
gem 'carrierwave'

# gem for get dfp info
gem 'google-dfp-api'

# manage data in js
gem 'underscore-rails'

# Date format for js
gem 'momentjs-rails'

# Decorators gem
gem 'draper', '~> 1.3'

# Analize other page data
gem 'pismo'

# Credential google auth
gem 'google-oauth2-installed'

# Conect with google apis
gem 'legato'

# Angular templates
gem 'angular-rails-templates'

# Manage assets
gem "bower-rails", "~> 0.10.0"

# Validate url
gem 'validate_url'

#Social analytics
gem 'social_shares', :github => "xleninx/social_shares"

#Take screen to page
gem 'cloudinary'

# ActiveAdmin
gem 'activeadmin', '~> 1.0.0.pre1'

# Slim html
gem 'slim'

# Devise
gem 'devise'

# Manage environment vars
gem 'dotenv-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Facebook gem API
gem "koala", "~> 2.2"

# Enumerate
gem 'enumerate_it'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'faker', '1.4.3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
end

group :production do
  gem 'rails_12factor', '0.0.3'
  # gem unicorn
  gem "unicorn-rails"
end
