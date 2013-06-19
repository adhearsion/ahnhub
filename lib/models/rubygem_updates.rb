migration "create the rubygem_updates table" do
  DB.create_table :rubygem_updates do
    primary_key  :id, primary_key: true
    Integer      :rubygem_id
    timestamp    :last_updated

    String       :name
    Integer      :downloads
    String       :version
    Integer      :version_downloads
    String       :platform
    String       :authors
    String       :info
    String       :project_uri
    String       :gem_uri
    String       :homepage_uri
    String       :wiki_uri
    String       :documentation_uri
    String       :mailing_list_uri
    String       :source_code_uri
    String       :bug_tracker_uri
  end
end

class RubygemUpdate < Sequel::Model
  many_to_one :rubygem

  def after_save
    unless rubygem = Rubygem.find(name: self.name)
      rubygem = Rubygem.create(
        name:              self.name,
        platform:          self.platform,
        authors:           self.authors,
        info:              self.info,
        downloads:         self.downloads,
        project_uri:       self.project_uri,
        gem_uri:           self.gem_uri,
        homepage_uri:      self.homepage_uri,
        wiki_uri:          self.wiki_uri,
        documentation_uri: self.documentation_uri,
        mailing_list_uri:  self.mailing_list_uri,
        source_code_uri:   self.source_code_uri,
        bug_tracker_uri:   self.bug_tracker_uri
      )
    end

    rubygem.update_info(self)
    rubygem.add_rubygem_update(self)
  end

  class << self
    def handle_hook(payload)
      update = self.create(
        name:              payload['name'],
        downloads:         payload['downloads'],
        version:           payload['version'],
        version_downloads: payload['version_downloads'],
        platform:          payload['platform'],
        authors:           payload['authors'],
        info:              payload['info'],
        project_uri:       payload['project_uri'],
        gem_uri:           payload['gem_uri'],
        homepage_uri:      payload['homepage_uri'],
        wiki_uri:          payload['wiki_uri'],
        documentation_uri: payload['documentation_uri'],
        mailing_list_uri:  payload['mailing_list_uri'],
        source_code_uri:   payload['source_code_uri'],
        bug_tracker_uri:   payload['bug_tracker_uri']
      )
    end
  end
end