@users
Feature: Users

    Background: A database exists
        Given a Niancat database
          And a team Mesh
    
    Scenario: Unique user ids
        Given a user Erik
          And a user Jenna
         Then Erik and Jenna have different user ids

    Scenario: Fetch a user
        Given a user Erik
          And a user Jenna
         When fetching a user Erik
         Then the user id for Erik matches the id when created

    Scenario: Fetch a user from team Mesh
        Given a user/team Erik in team Mesh
          And a user Jenna
         When fetching a user/team Erik in team Mesh
         Then the user id for Erik matches the id when created