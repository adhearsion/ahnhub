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

  get '/justin' do
    payload = {
      'repository' =>
      {
        'description' => "A gem for testing gem gems.",
        'name' => "JustinsGem",
        'forks' => "7",
        'watchers' => "69",
        'url' => "http://www.github.com/JustinAiken/foo",
        'owner' => {'name' => "JustinAiken", 'email' => "foo@bar.com"}
      },
      'commits' => [
      {
        'url' => "http://www.github.com/JustinAiken/foo",
        'timestamp' => Time.now,
        'message' => "Added something to gitignore",
        'author' => {'name' => "JustinAiken", 'email' => "60tonangel@gmail.com"}
      }
      ]
    }
    ParseGithubHook payload
    "ok"
  end

  get '/justingem' do
    payload = {
      "name"              => "JustinsGem",
      "downloads"         => 7,
      "version"           => "0.0.2",
      "version_downloads" => 0,
      "platform"          => "ruby",
      "authors"           => "Justin Aiken",
      "info"              => "A gem for testing gem gems.",
      "project_uri"       => "http://rubygems.org/gems/testfoo123",
      "gem_uri"           => "http://rubygems.org/gems/testfoo123-0.0.2.gem",
    }
    RubygemUpdate.handle_hook(payload)
    "ok"
  end

  get '/forcederror' do
    raise "Kablamo! An error has been forced."
  end
end
