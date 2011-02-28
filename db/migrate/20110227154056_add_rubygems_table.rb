class AddRubygemsTable < ActiveRecord::Migration
  def self.up
    create_table :rubygems do |t|
      t.string :name
      t.text :info
      t.string :version
      t.integer :version_downloads
      t.string :authors
      t.integer :downloads
      t.string :project_uri
      t.string :gem_uri
      t.string :homepage_uri
      t.string :source_code_uri
    end
  end

  def self.down
    remove_table :rubygems
  end
end
