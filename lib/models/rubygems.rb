class Rubygem < Sequel::Model
  one_to_one  :plugin
  one_to_many :rubygem_updates
end