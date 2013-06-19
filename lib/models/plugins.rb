migration "create the plugins table" do
  DB.create_table :plugins do
    primary_key  :id, primary_key: true
    timestamp    :last_updated, null: false

    String       :name
    String       :description
    String       :authors

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

  def timeline
    gem_events = []
    git_events = []

    if self.rubygem
      self.rubygems.rubygem_updates.each do |event|
        gem_events << {
          event: "New version #{event.version} released at #{event.last_updated}",
          at: event.last_updated
        }
      end
    end

    if self.github_repo
      self.github_repo.commits.each do |event|
        git_events << {
          event: "Updated at #{event.last_updated} by #{event.author} - foo",
          at: event.last_updated
        }
      end
    end

    events = gem_events.merge git_events

    events.sort_by { |event| event.at }
  end
end