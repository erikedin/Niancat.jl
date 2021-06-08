Feature: Users

    Background: A running service
        Given a game of Niancat in the default instance

    Scenario: Display name defaults to user id
        Given a user User1 in the default team
         When showing the user
         Then the displayed name is User1
    
    Scenario: Update display name
        Given a user User1 in the default team
         When the display name is updated to Erik
          And showing the user
         Then the displayed name is Erik
    