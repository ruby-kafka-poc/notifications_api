# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'aasm'
gem 'bcrypt'
gem 'dotenv-rails'
gem 'jwt'
gem 'kafka_rails_integration',
    git: 'https://github.com/ruby-kafka-poc/rails_kafka_integration.git', branch: 'allow_params'
# git: 'git@github.com:ruby-kafka-poc/rails_kafka_integration.git',
# ref: 'cc89338' # branch: 'added_lib' # tag: '2.0.1'
gem 'karafka', '>= 2.0.0.alpha2'
gem 'pg'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'

group :development, :test do
  gem 'bullet'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'formatador'
  gem 'rails_best_practices'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'spring'
end

group :test do
  gem 'rspec'
  gem 'simplecov'
  gem 'timecop'
end
