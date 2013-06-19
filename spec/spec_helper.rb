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

RUBY_SAMPLE_RESPONSE = {
  "name"              => "testfoo123",
  "downloads"         => 7,
  "version"           => "0.0.2",
  "version_downloads" => 0,
  "platform"          => "ruby",
  "authors"           => "Justin Aiken",
  "info"              => "A test gem",
  "project_uri"       => "http://rubygems.org/gems/testfoo123",
  "gem_uri"           => "http://rubygems.org/gems/testfoo123-0.0.2.gem",
  "homepage_uri"      => nil,
  "wiki_uri"          => nil,
  "documentation_uri" => nil,
  "mailing_list_uri"  => nil,
  "source_code_uri"   => nil,
  "bug_tracker_uri"   => nil,
  "dependencies"      => { "development" => [], "runtime" => []}
}