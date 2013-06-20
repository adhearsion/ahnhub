migration "create the plugins table" do
  DB.create_table :plugins do
    primary_key  :id, primary_key: true
    timestamp    :last_updated, null: false

    Integer      :rubygem_id
    Integer      :github_repo_id

    String       :rubygem_name
    String       :github_name
  end
end

class Plugin < Sequel::Model
  one_to_one :github_repo
  one_to_one :rubygem

  def has_github?
    self.github_repo != nil
  end

  def has_rubygem?
    self.rubygem != nil
  end

  def name
    if has_rubygem?
      self.rubygem.name
    else
      self.github_repo.name
    end
  end

  def description
    if has_rubygem?
      self.rubygem.info
    else
      self.github_repo.desc
    end
  end

  def owner
    if has_github?
      self.github_repo.owner
    else
      self.rubygem.authors
    end
  end

  def url
    if has_github?
      self.github_repo.url
    else
      "https://rubygems.org/gems/#{self.rubygem.name}"
    end
  end

  def timeline
    gem_events = []
    git_events = []

    if self.rubygem
      self.rubygem.rubygem_updates.each do |event|
        gem_events << {
          event: "New version #{event.version} released at #{event.last_updated}",
          last_updated: event.last_updated
        }
      end
    end

    if self.github_repo
      self.github_repo.commits.each do |event|
        git_events << {
          event: "Updated at #{event.last_updated} by #{event.author} - foo",
          last_updated: event.last_updated
        }
      end
    end

    events = gem_events.concat git_events

    events.sort_by { |event| event['last_updated'] }.reverse
  end
end