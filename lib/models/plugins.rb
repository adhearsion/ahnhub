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
end