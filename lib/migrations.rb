migration "create the plugins table" do
  database.create_table :plugins do
    primary_key  :id, primary_key: true
    String       :name
    String       :owner
    String       :desc
    String       :url
    String       :forks, :default => 0
    String       :watchers, :default => 0
    timestamp    :last_updated, :null => false
  end
end