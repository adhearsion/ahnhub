migration "create the rubygems table" do
  DB.create_table :rubygems do
    primary_key  :id, primary_key: true
    Integer      :plugin_id
    timestamp    :last_updated

    String    :name
    String    :platform
    String    :authors
    String    :info
    String    :downloads
    String    :project_uri
    String    :gem_uri
    String    :homepage_uri
    String    :wiki_uri
    String    :documentation_uri
    String    :mailing_list_uri
    String    :source_code_uri
    String    :bug_tracker_uri
  end
end

class Rubygem < Sequel::Model
  one_to_one  :plugin
  one_to_many :rubygem_updates

  def update_info(rubygem_update)
    self.last_updated = rubygem_update.last_updated
    self.downloads    = rubygem_update.downloads
  end

  def after_create
    #First, look for a plugin with the ruby gem name already stored...
    unless self.plugin
      #Next, look for a Plugin that has a github repo with the same rubygem name...
      unless Plugin.find(github_name: self.name)
        #Bah, it doens't exist.  Let's create it...

        plugin = Plugin.create(
          name: self.name,
          description: self.info,
          authors: self.authors,
          rubygem_name: self.name,
          last_updated: Time.now
        )
        plugin.rubygem = self
      end
    end
  end

  def after_save
    self.plugin.last_updated = self.last_updated if self.plugin
  end
end