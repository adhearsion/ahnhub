class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :homepage
      t.integer :watchers
      t.integer :forks
      t.boolean :privateflag
      t.string :ownername
      t.string :owneremail

      t.timestamps
    end
  end

  def self.down
    drop_table :repositories
  end
end
