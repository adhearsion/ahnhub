require 'json'
require 'haml'
require 'sinatra'
require 'sinatra/sequel'
require "sinatra/content_for"
require "sinatra/reloader"
require 'airbrake'

require File.dirname(__FILE__) + "/lib/notifications.rb"
require File.dirname(__FILE__) + "/lib/database.rb"

class AhnHub < Sinatra::Base
  helpers do
    include Sinatra::ContentFor
    include Rack::Utils
  end

  configure :production do
    Airbrake.configure do |config|
      config.api_key    = ENV['ERRBIT_API_KEY']
      puts "API_KEY: #{config.api_key}"
      config.host       = ENV['ERRBIT_API_HOST']
      puts "API_HOST: #{config.host}"
      config.port       = 80
      config.secure     = config.port == 443
    end

    use Airbrake::Rack
    enable :raise_errors
  end

  configure :development do
    register Sinatra::Reloader
    set :bind, '0.0.0.0'
  end

  def ParseGithubHook(payload)
    repo_info = payload['repository']
    commits   = payload['commits']

    puts "Repo Added: -- #{repo_info.inspect}"
    puts "Commits Added for #{repo_info['name']}: -- #{commits.inspect}"

    repo = GithubRepo.process_repo repo_info
    Commit.add_new_commits repo, commits
  end

  require_relative 'routes/faker_routes'
  require_relative 'routes/routes'
end

AhnHub.run! if __FILE__ == $0
