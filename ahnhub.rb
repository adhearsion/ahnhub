require 'json'
require 'haml'
require 'sinatra'
require 'sinatra/sequel'
require "sinatra/content_for"
require "sinatra/reloader"

require File.dirname(__FILE__) + "/lib/notifications.rb"
require File.dirname(__FILE__) + "/lib/database.rb"

class AhnHub < Sinatra::Base
  helpers Sinatra::ContentFor

  configure :development do
    register Sinatra::Reloader
    set :bind, '0.0.0.0'
  end

  @notify = Notifications.new

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
      @notify.tweet "A new plugin has been added to AhnHub called '#{repo_info['name']}'. Go check it out www.ahnhub.com!"
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
      @notify.tweet "The '#{repo_info['name']}' plugin has been updated. Check out the new changes!"
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

  require_relative 'routes/faker_routes'
  require_relative 'routes/routes'
end

AhnHub.run! if __FILE__ == $0
