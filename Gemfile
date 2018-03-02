# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Core ====================================================
gem 'rails', '~> 5.1.2'
gem 'pg'
gem 'puma', '~> 3.0'

# DB / Model ==============================================
gem 'acts_as_list', '~> 0.7.6'
gem 'devise', '~> 4.3.0'
gem 'aasm'
gem 'pundit'
gem 'geocoder', '~> 1.4.0'
gem "pg_search"
gem 'global_phone', '~> 1.0'
gem 'delayed_job_active_record'
gem 'jsonapi-rails'


# Asset pipeline ==========================================
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Views ====================================================
gem 'autoprefixer-rails', '~> 7.1.1'
gem 'bootstrap', '~> 4.0.0'
gem 'htmlentities', '~> 4.3.4'
gem 'slim', '~> 3.0.7'
gem 'font-awesome-rails'
gem 'kaminari'

# Uploads ================================================
gem 'paperclip', '~> 5.1'
gem 'paperclip-meta'
gem 'jquery-fileupload-rails', '~> 0.4.7'

# SMS ====================================================
gem 'rotp', '~> 3.3'
gem 'twilio-ruby', '~> 5.5'

#= NOTIFS =================================
group :production, :staging do
  #= NOTIFS =================================
  gem 'exception_notification', git: 'git://github.com/smartinez87/exception_notification.git'
  #= Outil pour delayed job en prod =========
  gem 'daemons'
end

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'capistrano'
  gem 'rvm-capistrano', require: false  
#  gem 'spring'
#  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test, :development do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'byebug', platform: :mri
  gem 'pry-rails'
  gem 'better_errors'
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_bot_rails'
  gem 'temping'
  gem 'poltergeist'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
