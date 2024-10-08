Feature: Login and Account Creation

Scenario: as system admin I should see all users
    Given I am logged into Arcade
    Then I should see "All Users"
    When I press "All Users"
    Then I should see "All Users"
    And I should see "Spongebob"
    And I should see "Patrick"
