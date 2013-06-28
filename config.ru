require 'rack'
require 'airbrake'

Airbrake.config do |config|
  config.api_key = ENV['ERRBIT_API_KEY']
  config.host = ENV['ERRBIT_API_HOST']
end

require File.dirname(__FILE__) + "/ahnhub"
$stdout.sync = true

app = Rack::Builder.AhnHub do
  run lambda { |env| raise "Rack down" }
end

use Airbrake::Rack
run AhnHub
