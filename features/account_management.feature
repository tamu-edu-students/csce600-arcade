Feature: Login and Account Creation

Scenario: view my profile as a logged in user
    Given I am logged into Arcade
    Then I should see "My Account"
    When I press "My Account"
    Then I should see "Profile"
    When I select "Profile" from the dropdown
    Then I should see "View Profile Details"
    And I should see "Spongebob"
    And I should see "Squarepants"
    And I should see "spongey@tamu.edu"

Scenario: edit my profile as a logged in user
    Given I am logged into Arcade
    Then I should see "My Account"
    When I press "My Account"
    Then I should see "Profile"
    When I select "Profile" from the dropdown
    Then I should see "View Profile Details"
    When I press "Edit Account"
    Then I should see "Profile Details"
    And I should not see "email"
