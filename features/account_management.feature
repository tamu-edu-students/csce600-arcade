Feature: Login and Account Creation

Scenario: view my profile as a logged in user
    Given I am logged into Arcade
    When I press "My Account"
    Then I should see "Profile"
    When I select "Profile" from the dropdown
    Then I should see "Profile Information"
    And I should see "Howdy Test"

Scenario: edit my profile as a logged in user
    Given I am logged into Arcade
    When I press "My Account"
    Then I should see "Profile"
    When I select "Profile" from the dropdown
    Then I should see "Profile Information"
    When I press "Edit account"
    Then I should see "Profile Details"
    And I should not see "email"
