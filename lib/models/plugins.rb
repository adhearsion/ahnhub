migration "create the plugins table" do
  DB.create_table :plugins do
    primary_key  :id, primary_key: true
    String       :name
    timestamp    :last_updated, null: false
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