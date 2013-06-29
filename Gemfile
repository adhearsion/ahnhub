source "http://rubygems.org"
ruby '1.9.3'

gem 'sinatra'
gem 'haml'
gem 'sequel'
gem 'sinatra-sequel'
gem 'sinatra-contrib'
gem 'twitter'
gem 'airbrake', "3.1.2"

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'rspec'
end
