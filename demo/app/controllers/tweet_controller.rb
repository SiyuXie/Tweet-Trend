class TweetController < ApplicationController
  before_action :authenticate_user!
  
  def search
    keyword = params[:search]
    country = params[:country]
    
    # if keyword == nil or keyword == ""
    #   if country != nil and country != ""
    #     @notice = "keyword is needed!"
    #   end
    #   return
    # end


    if keyword == ""
      @notice = "Keyword is needed!"
      return
    elsif keyword == nil
      return
    end

    
    @tweets = Tweet.search(keyword, country)
    
    if @tweets.length == 0
      @notice = "Tweets not found!"
      return
    else
      @notice = "Tweets found!"
    end
    
   
     @hash = Gmaps4rails.build_markers(@tweets) do |tweet, marker|
       marker.lat tweet[:lat]
       marker.lng tweet[:lng]
       marker.infowindow tweet[:text]
     end
    
     # @line = Array.new
     #
     # @tweets.each do |tweet|
     #   newHash = Hash.new
     #   newHash['lat'] = tweet[:lat]
     #   newHash['lng'] = tweet[:lng]
     #   @line.push(newHash)
     # end
  end
end
