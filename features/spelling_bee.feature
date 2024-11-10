Feature: Spelling Bee Game Page

  Scenario: Visiting Spelling Bee game page
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I press "How to Play"

  Scenario: Correct word
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I enter "chair" into the "sbenter" field
    And I click the submit button
    Then I should see "chair"

  Scenario: Not in dictionary
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I enter "uuuuu" into the "sbenter" field
    And I click the submit button
    Then I should see "The word 'UUUUU' is not in the dictionary."
  
  Scenario: No center letter
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I enter "church" into the "sbenter" field
    And I click the submit button
    Then I should see "The word must include the center letter 'A'."
  
  Scenario: Letter not in the 6 given
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I enter "mats" into the "sbenter" field
    And I click the submit button
    Then I should see "The word must be composed of the letters: R, C, H, I, U, T."

  Scenario: Ranks check
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Spelling Bee"
    Then I should see "Spelling Bee"
    And I enter "church" into the "sbenter" field
    And I click the submit button
    And I enter "chart" into the "sbenter" field
    And I click the submit button
    And I enter "attic" into the "sbenter" field
    And I click the submit button
    And I enter "attach" into the "sbenter" field
    And I click the submit button
    Then I should see "Amoeba"