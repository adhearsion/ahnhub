set :environment, ENV['RACK_ENV'].to_sym

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

require File.dirname(__FILE__) + "/migrations.rb"
Dir[File.dirname(__FILE__) + "/models/*.rb"].each {|f| require f}