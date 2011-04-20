class Repository < ActiveRecord::Base

  belongs_to :project

  has_many :commits, :dependent => :destroy, :order => 'created_at DESC'

  alias_attribute :private, :privateflag

  # Github support
  def self.update_or_create_from_github_push(payload)
    repository_data = payload["repository"]
    payload_url = repository_data["url"]

    repository = find_by_url(payload_url) || Repository.new

    repository.update_from_github_push payload

    repository.project = Rubygem.find_by_source_code_uri(repository.url).andand.project || Project.new if repository.new_record?

    repository.save
    repository
  end

  def update_from_github_push(payload)
    repository_data = payload["repository"]

    self.name = repository_data['name']
    self.description = repository_data['description']
    self.url = repository_data['url']
    self.homepage = repository_data['homepage']

    self.watchers = repository_data['watchers'] || 0
    self.forks = repository_data['forks'] || 0
    self.privateflag = repository_data['private'] || false

    owner_data = repository_data["owner"]
    if owner_data
      self.ownername = owner_data['name'] || ""
      self.owneremail = owner_data['email'] || ""
    end

    payload_commits = payload["commits"]

    if payload_commits.present?
      payload_commits.each do |commit_data|
        commit_sha_id = commit_data["id"]
        commit = Commit.find_by_shaid commit_sha_id

        unless commit
          commit = self.commits.build :shaid => commit_sha_id

          %w[url message added removed modified].each do |property_name|
            commit[property_name] = commit_data[property_name] if commit_data.has_key? property_name
          end

          author_data = commit_data['author']
          if author_data
            commit.authorname = author_data['name']
            commit.authoremail = author_data['email']
          end
          commit.save
        end
      end
    end
  end

end
