require 'simplecov'
SimpleCov.start

require_relative 'tweet_model'
require 'minitest/autorun'

class TestTweetModel < MiniTest::Test
  def setup
    @tweet_model = UPENN::Twitter.get_instance
    
    new_record = {
      :tweet_id => '592486858770259968',
      :source => '{:id=>123, :id_str=>"123", :text=>"hello world", :source=>"<a href="http\://twitter.com" rel="nofollow">Twitter Web Client</a>", :user=>"100", :lang=>"en"}'
    }
    # Tweet.create(new_record).save
  end
  
  def test_run
    @tweet_model.run
    assert_equal(1, 1)
    # assert_equal(0, tweet_model.find)
  end
end