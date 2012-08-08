Feature: Subtask
  As a user
  I want to have a subtask on my task
  so I can have more details on every task

  Background:
    Given the following boards:
      | name   | columns |
      | board1 | column1 |
    And the following tasks:
      | title | column  |
      | task1 | column1 |
    And the following subtasks:
      | content  | task    |
      | subtask1 | task1   |
      
  
  Scenario: user adds a subtask to a task
    Given the task list page of "board1"
    When I'm within the task "task1"
    And I click on "Open"
    And I fill in "Subtask" with "subtask1"
    And I click on "add-subtask"
    Then the database has a subtask "subtask1" that is related to "task1"
    And the task "task1" has a subtask "subtask1"
    And the "Subtask" field is blank

  #@wip
  Scenario: user removes a subtask from a task
    Given the task list page of "board1"
    When I'm within the task "task1"
    And I click on "Open"
    And I'm within the subtask "subtask1"
    And I click on "remove-subtask"
    Then the database hasn't a subtask "subtask1" that is related to "task1"
    And the task "task1" hasn't a subtask "subtask1"

