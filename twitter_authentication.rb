TweetStream.configure do |config|
  config.username             = "USERNAME"
  config.password             = "PASSWORD"
  config.auth_method          = :basic
  # OAuth preferred
  # config.consumer_key       = '1234567890'
  # config.consumer_secret    = 'asdfghjkl'
  # config.oauth_token        = 'asdfghjkl'
  # config.oauth_token_secret = 'asdfghjkl'
  # config.auth_method        = :oauth
end