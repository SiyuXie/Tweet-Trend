class Retweet < ActiveRecord::Base

  # validates :tweet_id, :retweet_user_id, :uniqueness => true
  belongs_to :tweet
  belongs_to :twitter_user
end
