class ReverseProjectAssociations < ActiveRecord::Migration
  def self.up
    remove_column :projects, :repository_id
    remove_column :projects, :rubygem_id
    add_column :rubygems, :project_id, :integer
    add_column :repositories, :project_id, :integer

    # Map existing repositories to new projects
    Repository.all.each do |r|
      p = r.create_project :created_at => r.created_at, :updated_at => r.updated_at
      r.project = p
      r.save
    end
  end

  def self.down
    add_column :projects, :repository_id, :integer
    add_column :projects, :rubygem_id, :integer
    remove_column :rubygems, :project_id
    remove_column :repositories, :project_id
  end
end
