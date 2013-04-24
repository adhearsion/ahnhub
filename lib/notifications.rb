require 'twitter'

class Notifications

  def initialize(params=nil)
  end

  def twitter_config(params)
    Twitter.configure do |config|
      config.consumer_key = params[:consumer_key]
      config.consumer_secret = params[:consumer_secret]
      config.oauth_token = params[:oauth_token]
      config.oauth_token_secret = params[:oauth_token_secret]
    end
  end

  def tweet(message)
    Twitter.update message 
  end

end
