migration "create the github_repos table" do
  DB.create_table :github_repos do
    primary_key  :id, primary_key: true
    Integer      :plugin_id
    String       :name
    String       :owner
    String       :desc
    String       :url
    String       :source
    String       :forks, default: 0
    String       :watchers, default: 0
    timestamp    :last_updated
  end
end

class GithubRepo < Sequel::Model
  one_to_one  :plugin
  one_to_many :commits
end