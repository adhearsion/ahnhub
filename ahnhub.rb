require 'json'
require 'haml'
require 'sinatra'
require 'sinatra/sequel'
require 'twitter'
require File.dirname(__FILE__) + "/lib/database.rb"

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
require File.dirname(__FILE__) + "/lib/migrations.rb"
Dir[File.dirname(__FILE__) + "/lib/models/*.rb"].each {|f| require f}

class AhnHub < Sinatra::Base

  get '/commitfakes' do
    plugin = Plugin.first 
    commit = Commit.create(:url => 'http://github.com/fakelink/',
                           :author => 'notBenLangfeld',
                           :message => 'PandaPower',
                           :updated_at => '2013-04-13')
    plugin.add_commit(commit)
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
    Plugin.create(:name => "adhearsion-pluggy",
                  :owner => "adhearsion",
                  :desc => "Adhearsion pluggy is a non-existant plugin for filling database space",
                  :url => "http://github.com/adhearsion/adhearsion-pluggy",
                  :forks => "7",
                  :watchers => "45",
                  :last_updated => Time.now,
                  :source => 'github')
    Plugin.create(:name => "adhearsion-huggy",
                  :owner => "jowens",
                  :desc => "Adhearsion huggy is a non-existant plugin for showing you some love after a rough phone call",
                  :url => "http://github.com/adhearsion/adhearsion-huggy",
                  :forks => "143",
                  :watchers => "143",
                  :last_updated => Time.now,
                  :source => 'rubygems')
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  get '/' do
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  get '/how' do
    haml :how
  end
  
  get '/about' do
    haml :about
  end

  post '/' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  post '/github' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.reverse_order(:last_updated).all
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

  def ParseGithubHook(payload)
    repo_info = payload['repository']
    commits = payload['commits']
    puts "Repo Added: -- #{repo_info.inspect}"
    puts "Commits Added for #{repo_info['name']}: -- #{commits.inspect}"
    plugin = AddGithubPlugin repo_info
    AddGithubCommits plugin, commits, repo_info
  end

  def AddGithubPlugin(repo_info)
    plugin = Plugin.where(:owner => repo_info['owner']['name'],
                          :name => repo_info['name'])

    if plugin.empty?
      plugin = Plugin.create(:name => repo_info['name'],
                    :owner =>  repo_info['owner']['name'],
                    :desc => repo_info['description'],
                    :url => repo_info['url'],
                    :forks => repo_info['forks'],
                    :watchers => repo_info['watchers'],
                    :last_updated => Time.now,
                    :source => 'github')
      Twitter.update("A new plugin has been added to AhnHub called #{repo_info['name']}. Go check it out!")
    else
      plugin.update( :name => repo_info['name'], 
                     :owner =>  repo_info['owner']['name'],
                     :desc => repo_info['description'],
                     :url => repo_info['url'],
                     :forks => repo_info['forks'],
                     :watchers => repo_info['watchers'],
                     :last_updated => Time.now,
                     :source => 'github')
      plugin = plugin.first # have to pull the actual plugin object from the dataset returned for associations
      Twitter.update("The #{repo_info['name']} has been updated. Check out the new changes!")
    end
    plugin
  end

  def AddGithubCommits(plugin, commits = nil, repo_info)
    if commits and plugin
      commits.each do |commit_info|
        commit = Commit.create(:url => commit_info['url'],
                               :author => commit_info['author']['name'],
                               :message => commit_info['message'],
                               :updated_at => commit_info['timestamp'])
        plugin.add_commit(commit)
      end
    end
  end
end

AhnHub.run! if __FILE__ == $0
