class AhnHub < Sinatra::Base
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
end