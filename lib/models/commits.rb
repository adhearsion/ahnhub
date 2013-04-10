class Commits < Sequel::Model
  many_to_one :plugins
end
