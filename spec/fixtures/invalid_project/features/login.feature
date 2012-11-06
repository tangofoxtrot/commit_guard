Feature: User logins in
  @firebug
  Scenario: User successfully logs in
    Given a user exists
    When the user logs in
    Then the user should see a success message
