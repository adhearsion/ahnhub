require 'json'
require 'haml'
require 'sinatra'
require 'sinatra/sequel'
require File.dirname(__FILE__) + "/lib/database.rb"

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
require File.dirname(__FILE__) + "/lib/migrations.rb"
Dir[File.dirname(__FILE__) + "/lib/models/*.rb"].each {|f| require f}

class AhnHub < Sinatra::Base

  get '/models' do
    plugin = Plugin.first 
    commit = Commit.create(:url => 'http://github.com/fakelink/',
                           :author => 'notBenLangfeld',
                           :owner => 'PandaPower',
                           :updated_at => '2013-04-13')
    else
      match = Plugin.where(:owner => repo_info['owner']['name'], :name => repo_info['name'])

    @plugins_view = Plugin.all
    haml :sequelmodel
  end

  get '/deletefakes' do
    plugins = DB[:plugins]
    plugins.delete
    @plugins_view = []
    haml :index
  end

  get '/addfakes' do
    plugins = DB[:plugins]
    plugins.insert(:name => "adhearsion-pluggy",
                  :owner => "adhearsion",
                  :desc => "Adhearsion pluggy is a non-existant plugin for filling database space",
                  :url => "http://github.com/adhearsion/adhearsion-pluggy",
                  :forks => "7",
                  :watchers => "45",
                  :last_updated => Time.now,
                  :source => 'github')
    plugins.insert(:name => "adhearsion-huggy",
                  :owner => "jowens",
                  :desc => "Adhearsion huggy is a non-existant plugin for showing you some love after a rough phone call",
                  :url => "http://github.com/adhearsion/adhearsion-huggy",
                  :forks => "143",
                  :watchers => "143",
                  :last_updated => Time.now,
                  :source => 'rubygems')
    @plugins_view = plugins.reverse_order(:last_updated).all
    haml :index
  end

  get '/' do
    plugins = DB[:plugins]
    @plugins_view = plugins.reverse_order(:last_updated).all
    haml :index
  end

  post '/' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.all
    haml :index
  end

  post '/github' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.all
    haml :index
  end

  post '/rubygems' do
    payload = {"params" => params}.to_json
    plugins = DB[:plugins]
    plugins.insert(:name => 'rubygems-webhook',
                   :desc => payload,
                   :owner => 'rubygems',
                   :url => 'http://url.tld',
                   :forks => '1',
                   :watchers => '1',
                   :last_updated => Time.now,
                   :source => 'rubygems')
  end

  post '/search' do
    query = params['query']
    result = Plugin.where(Sequel.like(:name, "%#{query}%")).or(
                          Sequel.like(:desc, "%#{query}%")).or(
                          Sequel.like(:owner, "%#{query}%")) 
    @search_string = query
    @plugins_view = result.reverse_order(:last_updated).all
    haml :index
  end

  get '/how' do
    haml :how
  end
  
  get '/about' do
    haml :about
  end

  def ParseGithubHook(payload)
    repo_info = payload['repository']
    new_plugin = Plugin.where(:owner => repo_info['owner']['name'],
                              :name => repo_info['name']).empty?
    if new_plugin
      Plugin.create(:name => repo_info['name'],
                     :desc => repo_info['description'],
                     :owner =>  repo_info['owner']['name'],
                     :url => repo_info['url'],
                     :forks => repo_info['forks'],
                     :watchers => repo_info['watchers'],
                     :last_updated => Time.now,
                     :source => 'github')
    else
      match = Plugin.where(:owner => repo_info['owner']['name'], :name => repo_info['name'])
      match.update( :name => repo_info['name'], 
                     :desc => repo_info['description'],
                     :owner =>  repo_info['owner']['name'],
                     :url => repo_info['url'],
                     :forks => repo_info['forks'],
                     :watchers => repo_info['watchers'],
                     :last_updated => Time.now,
                     :source => 'github')
    end
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
