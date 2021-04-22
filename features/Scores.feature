@scores
Feature: Scores for a Niancat-like game

    Background: Score persistence
        Given a database for scores

    Scenario: User gets a point for solving a puzzle
        Given a user with name Erik
         When the user solves a puzzle
         Then the user has score 1 on the scoreboard

    Scenario: User gets two points for two solutions to a single puzzle
        Given a user with name Erik
         When the user solves a puzzle
          And the user solves the puzzle again with a different solution
         Then the user has score 2 on the scoreboard

    @wip
    Scenario: User gets only one point for a given solution
        Given a user with name Erik
         When the user solves a puzzle
          And the user solves the puzzle again with the same solution
         Then the user has score 1 on the scoreboard