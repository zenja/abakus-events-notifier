require 'twitter'
require 'yaml'

class ZenjaTwitter
  attr_reader :twitter_config

  def initialize
    @twitter_config = YAML.load(File.open("./config/_twitter_account.yaml"))

    Twitter.configure do |config|
      config.consumer_key = @twitter_config["app"]["consumer_key"] 
      config.consumer_secret = @twitter_config["app"]["consumer_secret"]
      config.oauth_token = @twitter_config["app"]["oauth_token"]
      config.oauth_token_secret = @twitter_config["app"]["oauth_token_secret"]
    end
  end
  
  def tweet(text)
    Twitter.update text
    text
  end
end

