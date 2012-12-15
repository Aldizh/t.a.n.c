Feature: Login or Sign up for members and non-members
As a non-member or member,
I want to sign up my email
so that I can receive updates

Scenario: New member sign up
Given I am on the login page
And I follow "New User Sign up here!"
Then I should be on the sign up page
When I fill in "email" with "my_email@berkeley.edu"
And I press "Continue"
Then I should be on the thanks page


Scenario: New member can't sign up
Given I am on the login page
And I follow "New User Sign up here!"
Then I should be on the sign up page
And I press "Continue"
Then I should be on the sign up page

Scenario: Email must be unique during signup
Given the following members exist:
| status | member_type | email | password | city | zip |
| Pending | tibetan | aldizhupani@gmail.com | 1234 | Berkeley | 94705 |
And I am on the sign up page
When I fill in "email" with "aldizhupani@gmail.com"
And I press "Continue"
Then I should see "Your account could not be created because you already signed up"

Scenario: Must confirm account with code in email
Given the following members exist:
| status | member_type | email | password | city | zip |
| Pending | tibetan | aldizhupani@gmail.com | 1234 | Berkeley | 94705 |
When I logged in as "aldizhupani@gmail.com" with password "12345"
Then I should see "You already created an account with this email."

Scenario: New users can log in
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | mailing_list | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I am on the login page
When I fill in "email" with "petertsoi@gmail.com"
And I fill in "password" with "1234"
And I press "Login"
Then I should be on profile page

Scenario: Invalid user can't login
Given I am on the login page
When I fill in "email" with "bozo@hotmail.com"
And I fill in "password" with "HAHAHAHAHA"
And I press "Login"
Then I should see "Your login information is not correct."

Scenario: User can request password reset
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | mailing_list | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I am on the password reset page
When I fill in "email" with "petertsoi@gmail.net"
And I press "Reset Password"
Then I should see "You haven't signed up with that email!"
When I fill in "email" with "petertsoi@gmail.com"
And I press "Reset Password"
Then I should be on the password reset confirmation page

Scenario: Password reset request uses unique code
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | mailing_list | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I clicked the reset link for "petertsoi@gmail.com" with code "1234"
Then I should be on the password update page

Scenario: Password gets updated on reset
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | mailing_list | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I clicked the reset link for "petertsoi@gmail.com" with code "1234"
And I should be on the password update page
When I fill in "password" with "password1"
And I fill in "password_confirm" with "password1"
And I press "Update Password"
Then I should be on the reset success page

Scenario: Non-members can edit their profiles
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | non_member | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the non-member profile edit page
Scenario: Members can edit their profiles
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "first-name" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "last-name" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "first-name" with "Peter"
And I fill in "last-name" with "Piper"
And I fill in "city" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "zip" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "state" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "telephone" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "year_of_birth" with "never"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "country_of_birth" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
Scenario: Validate city
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
And I fill in "city" with "Berkeley"
And I fill in "zip" with "=)"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate zip
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "=)"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate state
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "94709"
And I fill in "state" with "99"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate telephone
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "94709"
And I fill in "state" with "CA"
And I fill in "telephone" with "=)"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate year of birth
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "94709"
And I fill in "state" with "CA"
And I fill in "telephone" with "8005555555"
And I fill in "year_of_birth" with "=)"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate country of birth
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "94709"
And I fill in "state" with "CA"
And I fill in "telephone" with "8005555555"
And I fill in "year_of_birth" with "1991"
And I fill in "country_of_birth" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."

Scenario: Validate special skills
Given the following members exist:
| status | member_type | email | first | last | password | zip |
| confirmed | tibetan | petertsoi@gmail.com | peter | tsoi | 1234 | 94709 |
And I logged in as "petertsoi@gmail.com" with password "1234"
And I am on profile page
When I follow "Edit your Profile"
Then I should be on the member profile edit page
And I fill in "first-name" with "foo"
And I fill in "last-name" with "bar"
And I fill in "address-line-1" with "foo"
And I fill in "city" with "Berkeley"
And I fill in "zip" with "94709"
And I fill in "state" with "CA"
And I fill in "telephone" with "8005555555"
And I fill in "year_of_birth" with "1991"
And I fill in "country_of_birth" with "USA"
And I fill in "special_skills" with "1234"
And I press "Continue"
Then I should see "Please enter the correct format/fill in all fields are required."
