migration "create the rubygems table" do
  DB.create_table :rubygems do
    primary_key  :id, primary_key: true
    Integer      :plugin_id
    String       :name
    timestamp    :last_updated
  end
end

class Rubygem < Sequel::Model
  one_to_one  :plugin
  one_to_many :rubygem_updates
end