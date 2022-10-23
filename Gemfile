# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

group :development do
  gem 'capistrano-rails'
  gem 'rvm1-capistrano3', require: false
  gem 'capistrano-bundler'
  gem 'capistrano-passenger', '0.0.2'
   
  gem 'net-ssh', '>= 6.0.2'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end
