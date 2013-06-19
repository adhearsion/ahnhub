require 'sinatra'
require 'rack/test'

# setup test environment
ENV['DATABASE_URL'] = 'sqlite://test.db'
ENV['RACK_ENV'] = 'test'
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  AhnHub
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

require File.dirname(__FILE__) + "/../ahnhub.rb"