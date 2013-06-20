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

  def self.process_repo(repo_info)
    github_repo = GithubRepo.where(owner: repo_info['owner']['name'], name: repo_info['name'])

    if github_repo.empty?
      github_repo = GithubRepo.create(
        name:         repo_info['name'],
        owner:        repo_info['owner']['name'],
        desc:         repo_info['description'],
        url:          repo_info['url'],
        forks:        repo_info['forks'],
        watchers:     repo_info['watchers'],
        last_updated: Time.now
      )
      Notifications.tweet "A new plugin has been added to AhnHub called '#{repo_info['name']}'. Go check it out www.ahnhub.com!"
    else
      github_repo = github_repo.first # have to pull the actual github_repo object from the dataset returned for associations

      github_repo.update(
        name:         repo_info['name'],
        owner:        repo_info['owner']['name'],
        desc:         repo_info['description'],
        url:          repo_info['url'],
        forks:        repo_info['forks'],
        watchers:     repo_info['watchers'],
        last_updated: Time.now
      )

      Notifications.tweet "The '#{repo_info['name']}' plugin has been updated. Check out the new changes!"
    end

    github_repo
  end

  def after_create
    unless self.plugin
      unless plugin = Plugin.find(rubygem_name: self.name)
        #Bah, it doens't exist.  Let's create it...

        plugin = Plugin.create(
          github_name: self.name,
          last_updated: self.last_updated
        )
      end

      plugin.github_repo = self
      self.plugin = plugin
    end

    super
  end
end