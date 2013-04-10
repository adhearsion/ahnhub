class Plugins < Sequel::Model
  one_to_many :commits
end
