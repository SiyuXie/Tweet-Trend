Feature:Test User Input
	To make sure the inputs from users are correct, or the user will receive error message
	
	Scenario: User enters a correct keyword
	Given I am in the getinput page
	When I enter a valid keyword
	Then I should be able to see the relevant tweets
	And I am in the search page 
	When I update a valid keyword
	Then I should be able to see the tweets with the updated keyword
	
	
	Scenario: User enters a incorrect keyword 
	Given I am in the getinput page again
	When I enter an invalid keyword
	Then I should be able to know the keyword is invalid and receive an error message
	And I am in the search page again
	
	
	Scenario: User doesnt enter a keyword, just enter country
	Given I am in the getinput page once again
	When I only enter a country name
	Then I should be able to see some error messages
	
	
	
	Scenario: User does not enter anything
	Given I am in the getinput page to enter something
	When I do not enter anything
	Then I will be back to the home page and receive an error message
	And I am in the search path 
	


	Scenario: User enter personal information after sign in
	Given I am in the user home page
	When I enter the name
	Then I should be able to know my information is save



	Scenario: No user name in the user personal information page
	Given I am in the user home page again
	When I update infomation without a name
	Then I will know the personal information is updated
	

	Scenario: User could search tweet
	Given I am in the search page again.
	When I type a valid keyword
	Then I will see some tweets
	
	Scenario: Website will store tweet
	Given I am in the search page and server has stored some tweets
	When I type a valid keyword again
	Then I will see some new tweets
	