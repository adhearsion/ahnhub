migration "create the plugins table" do
  DB.create_table :plugins do
    primary_key  :id, primary_key: true
    String       :name
    String       :owner
    String       :desc
    String       :url
    String       :source
    String       :forks, :default => 0
    String       :watchers, :default => 0
    timestamp    :last_updated, :null => false
  end
end

=begin commit example=
Github commits data match the structure below
{
...
:commits    => [{
    :id        => commit.id,
    :message   => commit.message,
    :timestamp => commit.committed_date.xmlschema,
    :url       => commit_url,
    :added     => array_of_added_paths,
    :removed   => array_of_removed_paths,
    :modified  => array_of_modified_paths,
    :author    => {
      :name  => commit.author.name,
      :email => commit.author.email
    }
  }],
...
}
=end

migration "create the commits table" do
  DB.create_table :commits do
    primary_key   :id, primary_key: true
    String        :plugin_id
    String        :url, :null => false
    String        :author, :null => false
    String        :message, :null => false
    String        :updated_at, :null => false
  end
end

