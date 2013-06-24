require 'twitter'

module Notifications
  def self.tweet(message)
    Twitter.update message
  rescue Exception => e
    puts e.inspect
    #Who cares, it's just a tweet.
  end
end