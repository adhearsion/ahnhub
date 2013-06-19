class GithubRepo < Sequel::Model
  one_to_one  :plugin
  one_to_many :commits
end