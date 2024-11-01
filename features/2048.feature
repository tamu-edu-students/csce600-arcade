Feature: 2048 Game
  As a player
  I want to play 2048 and customize its appearance
  So that I can enjoy the game with my preferred visual settings

  Scenario: Starting a new 2048 game
    Given I am on the login page
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "2048"
    And I should see "Play"
    When I click the Play button for "2048"
    Then I should see an empty 4x4 grid
    And I should see a score of "0"
    