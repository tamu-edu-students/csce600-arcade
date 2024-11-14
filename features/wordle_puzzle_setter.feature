Feature: Wordle Puzzle Setter

  Scenario: Visiting Wordle Play Setter Page
    Given I am on the login page
    When I login as System Admin
    And I visit the Wordle play page
    Then I click the Puzzle Settings button
    Then I should see 'apple'
    And I should see 'floop'

    Scenario: Visiting Wordle Dictionary Setter Page
    Given I am on the login page
    When I login as System Admin
    And I visit the Wordle play page
    Then I click the Puzzle Settings button
    Then I click the 'Wordle Dictionary' button
    Then I should see 'apple'
    And I should see 'floop'
    And I should see 'ploof'

    Scenario: Search and Sort Option on the Wordle Dictionary Setter Page
    Given I am on the login page
    When I login as System Admin
    And I visit the Wordle play page
    Then I click the Puzzle Settings button
    Then I click the 'Wordle Dictionary' button
    Then I should see 'Search and Sort Options'
    And I should see 'Update Wordle Dictionary'