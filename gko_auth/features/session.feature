Feature: Authentication

  Scenario: Attempt to access protected page
    When I go to the admin sites page
    Then I should not be on the admin sites page
    But I should be on the sign in page

  Scenario: Failed login
    Given a confirmed user with email "bob@domain.com" and password "bobpass"
    When I go to the sign in page
    And I fill in "Email" with "bob@domain.com"
    And I fill in "Password" with "notbobpass"
    And I press "Sign in"
    But I should be on the sign in page

  Scenario: Successful login
    Given a confirmed user with email "bob@domain.com" and password "bobpass"
    When I go to the admin sites page
    Then I should not be on the admin sites page
    And I should see "Sign in"
    When I fill in "Email" with "bob@domain.com"
    And I fill in "Password" with "bobpass"
    And I press "Sign in"
    Then I should be on the admin sites page
    