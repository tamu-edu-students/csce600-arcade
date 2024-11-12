Feature: Login and Account Creation

Scenario: as system admin I should see all users
    Given I am logged into Arcade
    When I press "All users"
    Then I should see "All Users"
