Feature: Role Management

@wip
Scenario: view all uesrs' roles
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    And I should see "Login with Google"
    When I login as System Admin
    Then I should see "Howdy Spongebob!"
    And I should see "You are logged in as System Admin"
    When I press "All User"
    Then I should see "All Users"
    Then I should see "Roles"
    And I should see "Member"
    And I should see "Aesthetician"
    And I should see "Setter"

@wip
Scenario: change user's role
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    And I should see "Login with Google"
    When I login as System Admin
    Then I should see "Howdy Spongebob!"
    And I should see "You are logged in as System Admin"
    When I press "All User"
    Then I should see "All Users"
    Then I should see "Roles"
    Then I should see "Add"
    Then I should see "Remove"