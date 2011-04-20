class ReverseProjectAssociations < ActiveRecord::Migration
  def self.up
    remove_column :projects, :repository_id
    remove_column :projects, :rubygem_id
    add_column :rubygems, :project_id, :integer
    add_column :repositories, :project_id, :integer
  end

  def self.down
    add_column :projects, :repository_id, :integer
    add_column :projects, :rubygem_id, :integer
    remove_column :rubygems, :project_id
    remove_column :repositories, :project_id
  end
end
