Feature: Playing the Wordle game
  As a player
  I want to guess words in the Wordle game
  So that I can win, lose, or make invalid guesses

  Background:
    Given the word for today is "apple"

  Scenario: Making a correct guess (Winning)
    Given I am on the Wordle play page
    When I guess the word "apple"
    Then I should see "Congratulations! You guessed the correct word!" on the Wordle page
    And I should see confetti on the screen

  Scenario: Making a wrong guess (Losing after 6 attempts)
    Given I am on the Wordle play page
    When I guess the word "mango" 6 times
    Then I should see "You've exhausted all your chances!" on the Wordle page
    And I should see the correct word was "apple"

  Scenario: Guessing a word with non-alphabet characters
    Given I am on the Wordle play page
    When I guess the word "a1pl3"
    Then I should see "must only contain English alphabets" on the Wordle page

  Scenario: Guessing a word shorter than 5 characters
    Given I am on the Wordle play page
    When I guess the word "app"
    Then I should see "must be 5 characters long" on the Wordle page

  Scenario: Guessing a word longer than 5 characters
    Given I am on the Wordle play page
    When I guess the word "apples"
    Then I should see "must be 5 characters long" on the Wordle page

  Scenario: Resetting the game session
    Given I am on the Wordle play page
    When I reset the game session
    Then I should see "Attempts: 0"
    And the game should be ready for new guesses

  Scenario: No word for today
    Given there is no word for today
    When I visit the Wordle play page
    Then I should see "Word not available" on the Wordle page
