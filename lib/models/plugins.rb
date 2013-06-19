class Plugin < Sequel::Model
  one_to_many :commits
  one_to_many :rubygem_updates
end