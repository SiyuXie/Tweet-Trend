
def sign_up
  email = 'abc@gmail.com'
  password = '123123123'
  User.new(:email => email, :password => password, :password_confirmation => password).save!
# visit '/users/sign_in'
  visit '/userinfos'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end

def some_useful_test 
  x = UPENN::Twitter.get_instance
   
  x.get_tweet(123)
  x.get_tweet(592524955620868100)

  x.get_retweet_user(123)
  x.get_user(123)

  x._is_useful_tweet({:place => 'abc'})
  x._is_useful_tweet({:retweeted_status => {:place => "abc"}})

  Tweet.search("hello", "china")
end

# Scenario: User enters a correct keyword
Given(/^I am in the getinput page$/) do
  sign_up
  visit(tweet_search_path)
end

When(/^I enter a valid keyword$/) do
  @keyword = 'i'
  fill_in 'Keyword', :with => @keyword 
end

Then(/^I should be able to see the relevant tweets$/) do
  
  click_button 'Search' 
  page.should have_content "found"
end

And(/^I am in the search page$/) do
   current_path.should == tweet_search_path
end

When(/^I update a valid keyword$/) do
  fill_in 'Keyword', :with => "a"
end

Then(/^I should be able to see the tweets with the updated keyword$/) do
  click_button 'Search' 
  page.should have_content "found"
end
#-------------------------------------------------------



# Scenario: User enters a incorrect keyword 
Given(/^I am in the getinput page again$/) do
  sign_up
  visit(tweet_search_path)
end

When(/^I enter an invalid keyword$/) do
  fill_in 'Keyword', :with => 's'
  fill_in 'Country', :with => 'Chocolate'
  click_button 'Search'
end

Then(/^I should be able to know the keyword is invalid and receive an error message$/) do
   page.should have_content('Tweets not found!')
end

And(/^I am in the search page again$/) do
  current_path.should == tweet_search_path
end
#-------------------------------------------------------




# Scenario: User doesnt enter a keyword, just enter country
Given(/^I am in the getinput page once again$/) do
  sign_up
  visit(tweet_search_path)
end

When(/^I only enter a country name$/) do
  fill_in 'Country', :with => 'Chocolate'
  click_button 'Search'
end

Then(/^I should be able to see some error messages$/) do
  page.should have_content('Tweets not found!')
end
#-------------------------------------------------------




# Scenario: User does not enter anything
Given(/^I am in the getinput page to enter something$/) do
  sign_up
  visit(tweet_search_path)
end

When(/^I do not enter anything$/) do
  click_button 'Search'
end

Then (/^I will be back to the home page and receive an error message$/) do
  page.should have_content('Keyword is needed!')
end

And(/^I am in the search path$/) do
  current_path.should == tweet_search_path
end


Given (/^I am in the user home page$/) do
  sign_up
  current_path.should == userinfos_path
end

When(/^I enter the name$/) do
  # click_button 'Edit'
  visit "/userinfos/1/edit"
  fill_in 'User name', :with => 'Harry Potter'
  click_button 'Update Userinfo'
end

Then(/^I should be able to know my information is save$/) do
  page.should have_content("Userinfo was successfully updated")
end

Given (/^I am in the user home page again$/) do
  sign_up
  # click_button 'Personal Profile'
  # click_button 'Edit'
  # new_record = {
  #       'user_name' => "-",
  #       'country' => '-'}
  #     Userinfo.create(new_record).save
  #     visit(userinfos_path)
  current_path.should == userinfos_path

  page.should have_content("abc@gmail.com")


end

When(/^I update infomation without a name$/) do
  # click_button 'Personal Profile'
  
    visit "/userinfos/1/edit"
    # new_record = {
    #     'user_name' => "-",
    #     'country' => '-'}
    #   Userinfo.create(new_record).save
  # click_button 'Edit Profile'
  click_button 'Update Userinfo'
end

Then(/^I will know the personal information is updated$/) do
  page.should have_content("Userinfo was successfully updated.")
end


Given (/^I am in the search page again\.$/) do
  sign_up
  
  x = UPENN::Twitter.get_instance
  
  tweet_object = {  "created_at": "MonApr2703: 05: 32+00002015",  "id": 592524955620868100,  "id_str": "592524955620868097",  "text": "hello world",  "source": "<ahref=\"http: //twitter.com/download/android\"rel=\"nofollow\">TwitterforAndroid</a>",  "truncated": false,  "in_reply_to_status_id": nil,  "in_reply_to_status_id_str": nil,  "in_reply_to_user_id": nil,  "in_reply_to_user_id_str": nil,  "in_reply_to_screen_name": nil,  "user": {  "id": 467962908,  "id_str": "467962908",  "name": "han!!",  "screen_name": "dvncing",  "location": "",  "url": "http: //s-olareclipse.tumblr.com",  "description": "isJadabaldwithoutherweave?#CONstruct",  "protected": false,  "verified": false,  "followers_count": 575,  "friends_count": 235,  "listed_count": 0,  "favourites_count": 3636,  "statuses_count": 12472,  "created_at": "ThuJan1901: 22: 54+00002012",  "utc_offset": -14400,  "time_zone": "EasternTime(US&Canada)",  "geo_enabled": true,  "lang": "en",  "contributors_enabled": false,  "is_translator": false,  "profile_background_color": "ACDED6",  "profile_background_image_url": "http: //abs.twimg.com/images/themes/theme18/bg.gif",  "profile_background_image_url_https": "https: //abs.twimg.com/images/themes/theme18/bg.gif",  "profile_background_tile": false,  "profile_link_color": "038543",  "profile_sidebar_border_color": "EEEEEE",  "profile_sidebar_fill_color": "F6F6F6",  "profile_text_color": "333333",  "profile_use_background_image": true,  "profile_image_url": "http: //pbs.twimg.com/profile_images/590339211296960512/u-_GAVp-_normal.jpg",  "profile_image_url_https": "https: //pbs.twimg.com/profile_images/590339211296960512/u-_GAVp-_normal.jpg",  "profile_banner_url": "https: //pbs.twimg.com/profile_banners/467962908/1430091855",  "default_profile": false,  "default_profile_image": false,  "following": nil,  "follow_request_sent": nil,  "notifications": nil  },  "geo": {  "type": "Point",  "coordinates": [  40.082071,  -76.584135  ]  },  "coordinates": {  "type": "Point",  "coordinates": [  -76.584135,  40.082071  ]  },  "place": {  "id": "00b88bfa5d1bb069",  "url": "https: //api.twitter.com/1.1/geo/id/00b88bfa5d1bb069.json",  "place_type": "city",  "name": "Maytown",  "full_name": "Maytown,PA",  "country_code": "US",  "country": "UnitedStates",  "bounding_box": {  "type": "Polygon",  "coordinates": [  [  [  -76.593374,  40.063143  ],  [  -76.593374,  40.092875  ],  [  -76.562642,  40.092875  ],  [  -76.562642,  40.063143  ]  ]  ]  },  "attributes": {}  },  "contributors": nil,  "retweet_count": 0,  "favorite_count": 0,  "entities": {  "hashtags": [],  "trends": [],  "urls": [],  "user_mentions": [],  "symbols": []  },  "favorited": false,  "retweeted": false,  "possibly_sensitive": false,  "filter_level": "low",  "lang": "en",  "timestamp_ms": "1430103932658" }
  x.store_tweet(tweet_object)
end

When(/^I type a valid keyword$/) do
  
  visit "/tweet/search"
  fill_in 'search', :with => 'hello'
  fill_in 'country', :with => 'UnitedStates'
  # fill_in 'country', :with => 'UnitedStates'
  
  click_button 'Search'
end

Then(/^I will see some tweets$/) do
  page.should have_content("found!")
end


Given (/^I am in the search page and server has stored some tweets$/) do
  sign_up
  
    
end

When(/^I type a valid keyword again$/) do
  x = UPENN::Twitter.get_instance
  
  x.run
  sleep 5
  x.stop
  sleep 3
  some_useful_test
  # x.start_work
  visit "/tweet/search"
  fill_in 'Keyword', :with => 'e'

  click_button 'Search'
end

Then(/^I will see some new tweets$/) do
  page.should have_content("found!")
end