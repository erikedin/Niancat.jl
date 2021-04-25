@wip @users
Feature: Users

    Background: A database exists
        Given a Niancat database
    
    Scenario: Unique user ids
        Given a user Erik
          And a user Jenna
         Then Erik and Jenna have different user ids

    Scenario: Fetch a user
        Given a user Erik
          And a user Jenna
         When fetching a user Erik
         Then the user id for Erik matches the id when created