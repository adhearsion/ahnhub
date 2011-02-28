class Rubygem < ActiveRecord::Base

  def self.update_or_create_from_gemcutter_push(payload)
    repository_data = payload["source_code_uri"] || nil
    raise StandardError "Must provide a source URL or homepage URL" if repository_data.nil?

    rubygem = find_by_project_uri(payload["project_uri"]) || self.new

    rubygem.update_from_rubygems_webhook payload
  end

  def update_from_rubygems_webhook(payload)
    self.name = payload['name']
    self.info = payload['info']
    self.version = payload['version']
    self.version_downloads = payload['version_downloads']
    self.authors = payload['authors']
    self.downloads = payload['downloads']
    self.project_uri = payload['project_uri']
    self.homepage_uri = payload['homepage_uri']
    self.source_code_uri = payload['source_code_uri']

    save
    self
  end

end
