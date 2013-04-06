require 'json'
require 'haml'
require 'sinatra'
require 'sinatra/sequel'
require File.dirname(__FILE__) + "/lib/database.rb"

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
require File.dirname(__FILE__) + "/lib/migrations.rb"
Dir[File.dirname(__FILE__) + "/lib/models/*.rb"].each {|f| require f}

class AhnHub < Sinatra::Base

  get '/fakeplugins' do
    plugins = DB[:plugins]
    plugins.insert(:name => "adhearsion-pluggy",
                  :owner => "adhearsion",
                  :desc => "Adhearsion pluggy is a non-existant plugin for filling database space",
                  :url => "http://github.com/adhearsion/adhearsion-pluggy",
                  :forks => "7",
                  :watchers => "45",
                  :last_updated => Time.now)
    plugins.insert(:name => "adhearsion-huggy",
                  :owner => "jowens",
                  :desc => "Adhearsion huggy is a non-existant plugin for showing you some love after a rough phone call",
                  :url => "http://github.com/adhearsion/adhearsion-huggy",
                  :forks => "143",
                  :watchers => "143",
                  :last_updated => Time.now)
  end

  get '/' do
    plugins = DB[:plugins]
    @plugins_view = plugins.reverse_order(:last_updated).all
    haml :index
  end

  post '/' do
    payload = JSON.parse(params[:payload])
    repo_info = payload['repository']
    plugins = DB[:plugins]

    new_plugin = plugins.where(:owner => repo_info['owner']['name'],
                               :name => repo_info['name']).empty?
    if new_plugin
      plugins.insert(:name => repo_info['name'],
                     :desc => repo_info['description'],
                     :owner =>  repo_info['owner']['name'],
                     :url => repo_info['url'],
                     :forks => repo_info['forks'],
                     :watchers => repo_info['watchers'],
                     :last_updated => Time.now )
    else
      match = plugins.where(:owner => "adhearsion", :name => "adhearsion-pluggy")
      match.update( :name => repo_info['name'], 
                     :desc => repo_info['description'],
                     :owner =>  repo_info['owner']['name'],
                     :url => repo_info['url'],
                     :forks => repo_info['forks'],
                     :watchers => repo_info['watchers'],
                     :last_updated => Time.now )
    end

    @plugins_view = plugins.all
    haml :index
  end

  post '/search' do
    query = params['query']
    plugins = DB[:plugins]
    result = plugins.where(Sequel.like(:name, "%#{query}%"))
    #result = plugins.where( Sequel.like(:name, "%#{query}%").sql_or, Sequel.like(:desc, "%#{query}%")) 
    @plugins_view = result.reverse_order(:last_updated).all
    haml :index
  end

  get '/how' do
    haml :how
  end
  
  get '/about' do
    haml :about
  end

end

=begin
  It would be awesome if this worked.
  
  It doesn't.

  #require File.dirname(__FILE__) + "/lib/migrations.rb"
  #Dir[File.dirname(__FILE__) + "/lib/models/*.rb"].each {|f| require f}

    NAME = 'RepoName'
    DESC = 'Description of Repository!'
    OWNER = 'bakemono'
    URL = 'github.com/bakemono/RepoName'
    FORKS = '5'
    WATCHERS = '20'
    Plugin.create(:name => NAME,
                  :desc => DESC,
                  :owner => OWNER,
                  :url => URL,
                  :forks => FORKS,
                  :watchers => WATCHERS,
                 )
=end

AhnHub.run! if __FILE__ == $0
