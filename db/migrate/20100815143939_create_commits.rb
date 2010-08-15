class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.integer :repository_id
      t.string :shaid
      t.string :url
      t.string :authorname
      t.string :authoremail
      t.text :message
      t.text :added
      t.text :removed
      t.text :modified
      t.datetime :committime

      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
