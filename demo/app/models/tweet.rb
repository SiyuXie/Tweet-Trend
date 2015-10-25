require 'tweet_model'

class Tweet < ActiveRecord::Base
   validates :tweet_id, :uniqueness => true
   has_one :twitter_user, :dependent => :destroy
   has_one :place, :dependent => :destroy
   has_many :retweets, :dependent => :destroy
   
  
  def self.search(search, country)#, city)
    @tweets = []
    if search == nil or search == ""
      return @tweets
      # search = ""
    end
    # if search == nil or search == ""
    #   search = " "
    # end
    if search
      constraint = {
        'text' => search,
        'country' => country
        # 'city' => city
      }

      x = UPENN::Twitter.get_instance
      # @tweets = []
      # x.search(constraint).each do |i|
      #   user_city = x.get_user(i[:user])[:location]
      #   if user_city == nil or user_city == ""
      #     next
      #   end
      #   puts '------------'
      #   puts user_city

      x.get_location_from_tweet_array(x.search(constraint)).each do |i|
        @tweets.push({
          :text => i[:text],
          :lat => i[:lat],
          :lng => i[:long],
          })
      end
    
    # loc = searchLocation(user_city)
        
    end
    return @tweets
  end
  # def self.makeLatLng(lat1, lng1, lat2, lng2)
  #   @polyline = Array.new

  # end

  # def self.searchLocation(city)
  #   geoinfo = Geocoder.search(city)
  #   return geoinfo.first.data["geometry"]["location"]
  # end
end
