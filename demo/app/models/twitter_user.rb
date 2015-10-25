class TwitterUser < ActiveRecord::Base
	validates :user_id, :uniqueness => true
  has_many :retweets, dependent: :destroy	
  belongs_to :tweet
end
