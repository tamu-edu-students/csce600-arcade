Feature: Settings

  Scenario: Viewing the Settings and it is persisted
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    And I should see "Login via SSO"
    When I login as System Admin
    Then I should see "Howdy Test!"
    When I press "Settings"
    Then I should see "Contrast"
    When I set the contrast to "80"
    Then the contrast value should be "80"
    Then I close the settings
    When I press "Settings"
    Then I should see "Contrast"
    Then the contrast value should be "80"