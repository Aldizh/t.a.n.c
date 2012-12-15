Feature: Editing member's profile 
   As a member, 
   I want to be able to edit my profile

Background:
    Given the following members exist:
    | status  | member_type  | email              | password | city | zip |
    | Pending | tibetan | aldizhupani@gmail.com | 1234     | Berkeley | 94705 |
    | confirmed | tibetan     | azhupani390@berkeley.edu | 34578 | San Francisco | 75201 |

Scenario: Editing Member data  information
   Given I logged in as "aldizhupani@gmail.com" with password "1234"
   And I am on the member profile edit page
   And I fill in "first-name" with "tenzin"
   And I fill in "last-name" with "zhupani"
   And I select "No" from "already_a_member"
   And I fill in "year_of_birth" with "1989"
   And I fill in "country_of_birth" with "Albania"
   And I select "Male" from "gender" 
   And I fill in "address-line-1" with "405 soda"
   And I fill in "address-line-2" with "UC Berkeley"
   And I select "0" from "number_of_children"
   And I fill in "city" with "Berkeley"
   And I fill in "state" with "CA"
   And I fill in "zip" with "94705"
   And I fill in "telephone" with "231313213"
   And I select "Student" from "occupation"
   And I press "Continue" 
   Then I should be on the edit success page

Scenario: Failing to edit member data because of missing fields
   Given I logged in as "aldizhupani@gmail.com" with password "1234"
   And I am on the member profile edit page
   And I fill in "first-name" with "tenzin"
   And I fill in "last-name" with "zhupani"
   And I select "No" from "already_a_member"
   And I fill in "year_of_birth" with "1989"
   And I fill in "country_of_birth" with "Albania"
   And I select "Male" from "gender" 
   And I fill in "address-line-1" with "405 soda"
   And I fill in "address-line-2" with "UC Berkeley"
   And I select "0" from "number_of_children"
   And I fill in "city" with "Berkeley"
   And I fill in "zip" with "94705"
   And I fill in "telephone" with "231313213"
   And I select "Student" from "occupation"
   And I press "Continue" 
   Then I should be on the member profile edit page

Scenario: Failing to edit member data because of wrong input
   Given I logged in as "aldizhupani@gmail.com" with password "1234"
   And I am on the member profile edit page
   And I fill in "first-name" with "89897989"
   And I fill in "last-name" with "zhupani"
   And I select "No" from "already_a_member"
   And I fill in "year_of_birth" with "1989"
   And I fill in "country_of_birth" with "Albania"
   And I select "Male" from "gender" 
   And I fill in "address-line-1" with "405 soda"
   And I fill in "address-line-2" with "UC Berkeley"
   And I select "0" from "number_of_children"
   And I fill in "city" with "Berkeley"
   And I fill in "zip" with "94705"
   And I fill in "telephone" with "231313213"
   And I select "Student" from "occupation"
   And I press "Continue" 
   Then I should be on the member profile edit page
Scenario: Editing Non-Member data  information
   Given I logged in as "azhupani390@berkeley.edu" with password "34578"
   And I am on the non-member profile edit page
   And I fill in "first-name" with "tenzin"
   And I fill in "last-name" with "zhupani"
   And I press "Submit" 
   Then I should be on the edit success page

Scenario: Failing to edit non-member data because of missing fields
   Given I logged in as "azhupani390@berkeley.edu" with password "34578"
   And I am on the non-member profile edit page
   And I fill in "first-name" with "Aldi"
   And I press "Submit" 
   Then I should be on the non-member profile edit page

Scenario: Failing to edit non-member data because of wrong input
   Given I logged in as "azhupani390@berkeley.edu" with password "34578"
   And I am on the non-member profile edit page
   And I fill in "first-name" with "89897989"
   And I fill in "last-name" with "zhupani"
   And I press "Submit" 
   Then I should be on the non-member profile edit page
