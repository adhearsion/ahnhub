class Commit < Sequel::Model
  many_to_one :plugins
end
