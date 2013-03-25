Feature: Bookmarks index

  Background:
    Given I am on the bookmarks index page

  Scenario: Index should have a title
    When I am on the article index page
    Then I should see the "Bookmarks Index" title
