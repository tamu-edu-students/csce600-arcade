Feature: Health Check

Scenario: ensure health check returns a green page
    Given I am on the health check page
    Then I should see a green blank page