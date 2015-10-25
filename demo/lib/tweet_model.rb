require_relative 'tweet_api'

# rails g model Tweet tweet_id:string source:text
# rails g model TwitterUser user_id:string source:text
# rails g model Place place_id:string source:text
#
# rails g model Retweet tweet_id:string retweet_user_id:string

def get_object(string)
  if string == nil
    return nil
  end
  
  null = nil
  begin 
    result = eval(string)
  rescue SyntaxError => se
    result = nil
  end
  return result
end

module StoreTweet
  def store_user(tweet_id, user_object)
    user_id = user_object[:id_str]
    source = user_object.to_s
    if (twitter_user = TwitterUser.find_by(user_id: user_id)) == nil
      new_record = {
        'user_id' => user_id, 
        'source' => source,
        'tweet_id' => tweet_id
      }
      twitter_user = TwitterUser.create(new_record)
      twitter_user.save
      return twitter_user
    else
      return twitter_user
    end
  end

  def store_place(tweet_id, place_object)
    place_id = place_object[:id]
    source = place_object.to_s
    if (place = Place.find_by(place_id: place_id)) == nil
      new_record = {
        'place_id' => place_id, 
        'source' => source,
        'tweet_id' => tweet_id
      }
      place = Place.create(new_record)
      place.save   
      return place 
    else
      return place
    end
  end

  def store_tweet(tweet_object)
    tweet_id = tweet_object[:id_str]
    # extract user info
    user_id = tweet_object[:user][:id_str]
    user_object = tweet_object[:user]
    tweet_object[:user] = user_id
    # extract retweeted tweet
    retweeted_object = tweet_object[:retweeted_status]
    tweet_object[:retweeted_status] = nil
    # extract geo info if exists
    if tweet_object[:place] != nil
      place_id = tweet_object[:place][:id]
      place_object = tweet_object[:place]
      tweet_object[:place] = place_id
      user_object[:place] = place_id
    else
      place_id = nil
      place_object = nil
    end
  
    if (@new_tweet = Tweet.find_by(tweet_id: tweet_id)) == nil
      tweet_object[:text].encode!('UTF-8', 'UTF-8', :invalid => :replace, :replace => '')
      source = tweet_object.to_s
      new_record = {
        'tweet_id' => tweet_id, 
        'source' => source
      }
      @new_tweet = Tweet.create(new_record)
      @new_tweet.save
    end
  
    if user_object != nil
      @new_twitter_user = store_user(@new_tweet.id, user_object)
    end
  
    if place_object != nil
      @new_place = store_place(@new_tweet.id, place_object)
    end

    if retweeted_object != nil
      # store retweeted tweet
      @original_tweet = store_tweet(retweeted_object)
      # store retweet relation
      original_tweet_id = retweeted_object[:id_str]
      retweet_user_id = user_id
      # store_retweet_relation(original_tweet_id, retweet_user_id)
      store_retweet_relation(@original_tweet.id, @new_twitter_user.id)
    end
    
    return @new_tweet
  end

  def store_retweet_relation(tweet_id, retweet_user_id)
    if Retweet.find_by(tweet_id: tweet_id, twitter_user_id: retweet_user_id) == nil
    # if Retweet.find_by(tweet_id: tweet_id, retweet_user_id: retweet_user_id) == nil
      # new_record = {
      #   'tweet_id' => tweet_id,
      #   'retweet_user_id' => retweet_user_id
      # }
      new_record = {
        'tweet_id' => tweet_id,
        'twitter_user_id' => retweet_user_id
      }
      Retweet.create(new_record).save
    end
  end
end

module GetTweet
  include StoreTweet

  # input: tweet_id - int/string
  # output: json object
  def get_tweet(tweet_id)
    tweet_id = tweet_id.to_s
    
    result = Tweet.find_by(tweet_id: tweet_id)
  
    if(result == nil)
      result = get_statuses_show(tweet_id)
      if result == nil
        return {}
      end
      
      # populate Tweet database
      #fix
      # source = result
      # new_record = {
      #   'tweet_id'=>tweet_id,
      #   'source'=>source
      # }
      # Tweet.create(new_record).save
    end
  
    return get_object(result.source)
  end

  # input: tweet_id - int/string
  # output: [user_id, user_id, ...]
  def get_retweet_user(tweet_id)
    tweet_id = tweet_id.to_s
    
    result = Retweet.where("tweet_id = #{tweet_id}")

    if(result.length == 0)
      tweet_array = get_statuses_retweets(tweet_id)
      
      if tweet_array == nil
        store_retweet_relation(tweet_id, -1)
        return []
      end
      
      get_object(tweet_array).each do |tweet_object|
        store_tweet(tweet_object)
      end    
       
      result = Retweet.where("tweet_id = #{tweet_id}")
    end
  
    user_array = []
    result.each do |record|
      if record.twitter_user_id == -1
        next
      end
      user_array.push(record.twitter_user_id)
    end

    return user_array
  end

  def get_user(user_id)
    user_id = user_id.to_s
    
    result = TwitterUser.find_by(user_id: user_id)
    if(result == nil)
      return {}
      # source = get_statuses_show(tweet_id)
      # new_record = {
      #   'tweet_id'=>tweet_id,
      #   'source'=>source
      # }
      # Tweet.create(new_record).save
    end
  
    return get_object(result.source)
  end
  
  def get_place(place_id)
    place_id = place_id.to_s
    
    result = Place.find_by(place_id: place_id)
    if(result == nil)
      return nil
      # source = get_statuses_show(tweet_id)
      # new_record = {
      #   'tweet_id'=>tweet_id,
      #   'source'=>source
      # }
      # Tweet.create(new_record).save
    end
  
    return get_object(result.source)
  end
end

module TweetFetcher
  include StoreTweet
  
  # @will_store = true
  #
  # def will_store
  #   @will_store
  # end
  #
  # def will_store= x
  #   @will_store = x
  # end
  
  
  def run
    @total_tweet = 0
    @running = true
    
    puts 'tweet db is running..'

    my_thread = Thread.new do
      get_statuses_sample do |tweet|
        
        if !@running
          return
        end
        
        @total_tweet += 1
        puts "a new tweet #{@total_tweet}"
        # puts tweet
        tweet_object = get_object(tweet)
        if _is_useful_tweet(tweet_object)
        # if @will_store and _is_useful_tweet(tweet_object)
          puts 'going to store'
          # fix
          puts tweet_object
          puts '------'
          # new tweet, store in database
          store_tweet(tweet_object)
        end
      end
    end
  end
  
  def stop
    @running = false
  end
  
  def _is_useful_tweet(tweet_object)
    # tweet is useful if it has geo information
    # @tmp0 += 1
    # if tweet_object[:place] == nil
    #   @tmp1 += 1
    # end
    #
    # if tweet_object[:retweeted_status] != nil
    #   @tmp2 += 1
    #   if tweet_object[:retweeted_status][:place] != nil
    #     @tmp3 += 1
    #   end
    # end
    
    if tweet_object == []
      return false
    end

    if tweet_object[:place] != nil
      return true
    end
    
    if tweet_object[:retweeted_status] != nil
      if tweet_object[:retweeted_status][:place] != nil
        return true
      end
    end
    
    return false
    # null = Twitter::NullObject.get
    # return status.place != null
  end
  
end

module FindGeoTweet
  include GetTweet
  
  def start_work
    # # index = Tweet.all.length
    # index = Tweet.first.id
    # batch_size = 10   # handle at most batch_size tweet at one time
    #
    # my_thread = Thread.new do
    #   while true
    #     index_next = [Tweet.last.id, index + batch_size].min
    #     if index_next == index
    #       sleep(5)
    #     end
    #
    #     # Tweet.find(:all, :order => "id desc", :limit => index_next - index).reverse.each do |tweet_record|
    #     Tweet.where("id >= #{index} and id < #{index_next}").each do |tweet_record|
    #       tweet_id = tweet_record.tweet_id
    #       tweet_object = get_object(tweet_record.source)
    #
    #       original_tweet_user_id = tweet_object[:user]
    #       original_tweet_user_location = get_user(original_tweet_user_id)[:location]
    #
    #       # if tweet_object[:place] == nil
    #       #   next
    #       # end
    #
    #       # tweet_place_object = get_place(tweet_object[:place])
    #
    #       get_retweet_user(tweet_id).each do |retweet_user_id|
    #         # retweet_user_object = get_user(retweet_user_id)
    #         retweet_user_location = get_user(retweet_user_id)[:location]
    #         if original_tweet_user_location != nil and original_tweet_user_location != "" and retweet_user_location != nil and retweet_user_location != ""
    #           do_work({
    #             :op_location => original_tweet_user_location,
    #             :rt_location => retweet_user_location
    #           })
    #         end
    #       end
    #     end
    #
    #     index = index_next
    #   end
    # end
  end
      
  # should rewrite
  def do_work(info)
    # puts '---------------------'
    # puts info
  end
end   

module TweetFilter
  def search(constraint)
    result = []
    
    Tweet.all.each do |tweet_record|
      tweet_id = tweet_record.tweet_id
      tweet_object = get_object(tweet_record.source)
      
      all_match = true
      
      constraint.each do |pair|
        key = pair[0]
        value = pair[1]
        all_match = all_match && match_constraint(tweet_object, key, value)
      end

      if all_match
        result.push tweet_object
      end
    end

    return result
  end
  
  def get_location_from_tweet_array tweet_array
    result  = []
    
    tweet_array.each do |x|
      place = get_place(x[:place])
      if place == nil or place == {}
        next
      end
      
      loc = get_place(x[:place])[:bounding_box][:coordinates][0][0]

      result.push({
        :tweet => x,
        :text => x[:text],
        :long => loc[0],
        :lat => loc[1]
        })
    end
    
    return result
  end
    
  
  # modify here:
  def match_constraint(tweet, key ,value)
    if value == "" or value == nil
      return true
    end
    
    if key == 'text'
      content = tweet[:text]
      return match_content_value(content, value, 'fuzzy')
    elsif key == 'country'
      if tweet[:place] != nil and get_place(tweet[:place]) != nil
        content = get_place(tweet[:place])[:country]
        return match_content_value(content, value, 'precise')
      else
        return false
      end
    else 
      puts 'error. ========= no matching constraint'
      return false
    end
  end

  def match_content_value content, value, precise_or_fuzzy
    if value == "" or value == nil
      return true
    else      
      if precise_or_fuzzy == 'precise'
        return content.downcase == value.downcase       
      elsif precise_or_fuzzy == 'fuzzy'
        return content.downcase.include? value.downcase 
      else
        puts 'error!!!!!!!!!!!!!!!!!!'       
      end
    end
  end
end 

module UPENN

class Twitter
  include StoreTweet
  include GetTweet
  include TweetFetcher
  include FindGeoTweet
  include TweetFilter
  
  @@twitter_instance = nil

  public
  
  # def tmp
  #   @tmp
  # end
  
  def Twitter.get_instance
    if @@twitter_instance == nil
      @@twitter_instance = Twitter.new
    end
    return @@twitter_instance
  end
  
  private
  def initialize
    x = 1
  end
end

end
  

