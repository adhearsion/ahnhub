class Commit < Sequel::Model
  many_to_one :github_repo
end
