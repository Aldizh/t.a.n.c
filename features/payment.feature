Feature: Paying membership fee
   As a member of the organization
   I want to be able to pay $25 for membership fees

Background:
    Given the following members exist:
    | status  | member_type  | email              | password | city | Zip |
    | Pending | mailing list | hjvds@berkeley.edu | 1234     | Berkeley | 94705 |
    | confirmed | member     | azhupani390@berkeley.edu | 34578 | San Francisco | 75201 |


Scenario: Paying membership fee by check or cash
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the member payment page
   And I press "Check or Cash"
   Then I should be on the Check Cash page
   Then I press "Done!" 
   Then I should be on the Thank You page

Scenario: Paying membership fee by online payment
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the member payment page
   And I press "Online Payment"
   Then I should be on the online payment page
   Then I press "Done!" 
   Then I should be on the Thank You page

Scenario: Not paying membership fee
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the member payment page
   And I press "Not Paying!"
   Then I should be on the Thank You page
