class Repository < ActiveRecord::Base
  has_many :commits
  #is_gravtastic!
  
end
