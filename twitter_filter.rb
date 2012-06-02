require 'tweetstream'
require File.join(File.dirname(__FILE__), 'tweet_store')

STORE = TweetStore.new

TweetStream.configure do |config|
  config.username             = 'andistuder'
  config.password             = "revoluti0n"
  config.auth_method          = :basic
  # config.consumer_key       = '0ho6o2BtFdBiWeauSmlS9w'
  # config.consumer_secret    = 'T8lydFk5C8TceYbjMdxYRFUdPHZKUo3ra9BVs13iPUo'
  # config.oauth_token        = 'powergameonline'
  # config.oauth_token_secret = 'roundhouse123!@#'
  # config.auth_method        = :oauth
end


TweetStream::Client.new.track('lol') do |status|
  # Ignore replies. Probably not relevant in your own filter app, but we want
  # to filter out funny tweets that stand on their own, not responses.
  if status.text !~ /^@\w+/
    # Yes, we could just store the Status object as-is, since it's actually just a
    # subclass of Hash. But Twitter results include lots of fields that we don't
    # care about, so let's keep it simple and efficient for the web app.
    hash1 = {'id' => status[:id],
    'text' => status.text,
    'username' => status.user.screen_name,
    'userid' => status.user[:id],
    'name' => status.user.name,
    'profile_image_url' => status.user.profile_image_url,
    'created_at' => status.created_at,
    'received_at' => Time.new.to_i}
    puts "ANDI#{hash1}"
    # puts
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
