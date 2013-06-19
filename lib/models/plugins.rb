class Plugin < Sequel::Model
  one_to_one :github_repo
  one_to_one :ruby_gem
end