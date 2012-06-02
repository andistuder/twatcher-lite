require 'json'
require 'redis'
require File.join(File.dirname(__FILE__), 'tweet')

class TweetStore
  
  REDIS_KEY = 'tweets'
  NUM_TWEETS = 20
  TRIM_THRESHOLD = 100
  
  def initialize
    @db = Redis.new
    @trim_count = 0
  end
  
  # Retrieves the specified number of tweets, but only if they are more recent
  # than the specified timestamp.
  def tweets(limit=15, since=0)
    @db.lrange(REDIS_KEY, 0, limit - 1).collect {|t|
      Tweet.new(JSON.parse(t))
    }.reject {|t| t.received_at <= since}
  end
  
  def push(data)
    @db.lpush(REDIS_KEY, data.to_json)
    @trim_count += 1
    if (@trim_count > TRIM_THRESHOLD)
      @db.list_trim(REDIS_KEY, 0, NUM_TWEETS)
      @trim_count = 20
    end
  end
  
end
