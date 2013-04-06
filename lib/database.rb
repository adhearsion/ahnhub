set :environment, :development
set :database,    'sqlite::memory'

=begin
puts "The foo table doesn't exist!" if !database.table_exists?('foos')

migration "create teh foos table" do
  database.create_table :foos do
    primary_key :id
    text        :bar
    integer     :baz, :default => 42
    timestamp   :bizzle, :null => false

  index :baz, :unique => true
  end
end

# you can also alter tables
# if only you could access them
migration "everything's better with bling" do
  database.alter_table :foos do
    drop_column :baz
    add_column :bling, :float
  end
end

puts "The foo table does exist!" if database.table_exists?('foos')
=end

