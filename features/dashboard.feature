Feature: Dashboard

  Background:
    Given I am logged into Arcade

  Scenario: Viewing the dashboard
    When I visit the dashboard page
    Then I should see "Welcome to Your Dashboard!"
    And I should see "Total Games Played"
    And I should see "Total Games Won"
    And I should see "Last Played"
    And I should see "Wordle"

  Scenario: Guest user tries to access dashboard
    Given I am a guest user
    When I try to visit the dashboard page
    Then I should see "Welcome, Guest!"
