@wip
Feature: Wordle Game Page

  Scenario: Visiting Wordle game page
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Letter Boxed"
    And I should see "Play"
    When I click the Play button for "Letter Boxed"
    Then I should see "Letter Boxed"