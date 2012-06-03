require 'tweetstream'
require File.join(File.dirname(__FILE__), 'tweet_store')

load File.join(File.dirname(__FILE__), 'twitter_authentication.rb')
# if Twitter authentication file not available uncomment and update config below
# TweetStream.configure do |config|
#   config.username             = "USERNAME"
#   config.password             = "PASSWORD"
#   config.auth_method          = :basic
#   # OAuth preferred
#   # config.consumer_key       = '1234567890'
#   # config.consumer_secret    = 'asdfghjkl'
#   # config.oauth_token        = 'asdfghjkl'
#   # config.oauth_token_secret = 'asdfghjkl'
#   # config.auth_method        = :oauth
# end


STORE = TweetStore.new

TweetStream::Client.new.track('lol') do |status|
  # Ignore replies. Probably not relevant in your own filter app, but we want
  # to filter out funny tweets that stand on their own, not responses.
  if status.text !~ /^@\w+/
    # Yes, we could just store the Status object as-is, since it's actually just a
    # subclass of Hash. But Twitter results include lots of fields that we don't
    # care about, so let's keep it simple and efficient for the web app.
    STORE.push(
      'id' => status[:id],
      'text' => status.text,
      'username' => status.user.screen_name,
      'userid' => status.user[:id],
      'name' => status.user.name,
      'profile_image_url' => status.user.profile_image_url,
      'created_at' => status.created_at,
      'received_at' => Time.new.to_i
    )
  end
end
