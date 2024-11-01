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

  # @javascript
  # Scenario: Moving tiles in 2048
  #   Given I am playing 2048
  #   When I press the "right" arrow key
  #   Then the tiles should move accordingly
  #   And new tiles should appear

  # Scenario: Customizing 2048 aesthetics
  #   Given I login as System Admin
  #   And I should see a list of games
  #   And I should see "2048"
  #   And I should see "Play"
  #   When I click the Play button for "2048"
  #   Then I should see "2048"
  #   And I should see an empty 4x4 grid
  #   And I should see a score of "0"
  #   When I click the Aesthetic Settings button
  #   Then I should see color customization options
  #   When I change the tile color to "#FF5733"
  #   Then the tile colors should update to "#FF5733"
  #   And the changes should be saved