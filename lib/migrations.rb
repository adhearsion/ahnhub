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
    Integer       :plugin_id
    String        :url, :null => false
    String        :author, :null => false
    String        :message, :null => false
    String        :updated_at, :null => false
  end
end

# EXAMPLE RESPONSE FROM RUBYGEMS:
# {
#   "name"              => "testfoo123",
#   "downloads"         => 7,
#   "version"           => "0.0.2",
#   "version_downloads" => 0,
#   "platform"          => "ruby",
#   "authors"           => "Justin Aiken",
#   "info"              => "A test gem",
#   "project_uri"       => "http://rubygems.org/gems/testfoo123",
#   "gem_uri"           => "http://rubygems.org/gems/testfoo123-0.0.2.gem",
#   "homepage_uri"      => nil,
#   "wiki_uri"          => nil,
#   "documentation_uri" => nil,
#   "mailing_list_uri"  => nil,
#   "source_code_uri"   => nil,
#   "bug_tracker_uri"   => nil,
#   "dependencies"      => { "development" => [], "runtime" => []}
#  }