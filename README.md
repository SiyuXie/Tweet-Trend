# TweetTrend

### ReadMe

Users can :
sign up with his/her email and password;
log in and begin search for relevant tweets after signing up an account.
search tweets with keyword and country;
see the search results on the map

What we achieved:
after running the service, tweets are automatically stored in the database
provide users with log in and search method
search the relevant tweets in our database
show the search results on the map 

### Boot Instruction:

1. run the server in console mode, and type command:

` UPENN::Twitter.get_instance.run` 

If you see a message like ‘a new tweet #’, it indicates there is a new tweet. If you see a message ‘going to store' and some transaction behind it, it indicates the server is storing the tweet. Not all tweet will be store, since we are drawing google maps, we only want tweets which have geographic information.

Wait for about half minute, or more time if you want, then turn off the server. Now several tweets have been stored in the database. You could verify this by typing ‘Tweet.all.length’ in console mode. The result should not be 0.

Here we haven’t let the server fetching tweets automatically, because there is a rate limit set by twitter server. Letting the server fetching tweets every time it starts might lead to breaking the rate limit. 

2. Run the server (rails s), and go to this website:

` localhost:3000/ `

sign up a new account and log in.

3. The browser will jump to the search page. Type some keyword and country name, and click ‘search’. The result will be displayed in two ways, one is through Google map, one is through HTML form.

Some time there is some notice ‘no tweet found’, it’s because there is no such tweet with the keyword and country name. Try with a more common keyword, or run the server in console mode and fetch more tweets.

The search is case insensitive. The keyword is searched in tweet text in fuzzy mode, while the country name is searched in precise mode. 


### Model:

We are currently using four tables in this iteration:

Tweet tweet_id:string source:text
TwitterUser user_id:string source:text
Place place_id:string source:text
Retweet tweet_id:string retweet_user_id:string

The table ‘Tweet’ stores all information about tweet, such as time of creation, tweet text, tweet id and so on.
The table ‘TwitterUser’ stores information about twitter users, such as their name, location, description, friends count, and so on.
The table ‘Place’ stores information about a location including full name, country, latitude, longitude and so on.
The table ‘Retweet’ stores the retweet relation.

Three of these tables, Tweet, TwitterUser and Place has a special field called ‘source’, which stores source text we get from twitter server. We decided not to store separate fields, for example, not to store the table ‘Tweet’ as a schema (created at, text, id, user id, place id, retweet count, lang, ..), because of two reasons. Firstly the source text is very complex with many fields and many levels, if we want to store all the information in relational database giving every different value a different column, the database will be too complicated. Secondly, we might need to remove some useless information if we want to avoid complexness, but we’re not sure we won’t use more information later, so it’s better to keep all of them.

There are also several validations in the database:

validates :tweet_id, :uniqueness => true
validates :tweet_id, :retweet_user_id, :uniqueness => true
validates :tweet_id, :uniqueness => true

In brief, all column name ending with ‘_id’ are candidate key of the database. We need them to retrieve data.

### Controller:

Implement user access control by devise:

application_controller: Add the before_filter in ApplicationController, so any request to controller must be filtered and if unauthenticate, it will redirect to the sign in page.

users_controller: Render the sign in and sign up page to users and interact with devise.

omniauth_callbacks_controller: this is the callback controller for oauth and will be invoked by devise after user choosing to sign in with twitter account.

getinputs_controller: This controller is to get input from the user, e.g. the search keywords of tweets or country. By getting the search keywords, this controller will call the ‘search’ method in tweet.db and pass the result back to getinputs_controller. A keyword is needed for the search method and the country and city is optional. After the user click the ‘Search’ button, the website will redirect to the ‘~/getinputs/search’ page where search result shown on the map.

