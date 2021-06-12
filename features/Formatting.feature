Feature: Formatting messages

    Background: A Niancat game
        Given a default Niancat service

    Scenario: Slack formatting
        Given that the team defaultteam uses Slack formatting in Swedish
         When we format a Correct("PUSSGURKA") response
         Then the formatted response is
            """
            Ordet PUSSGURKA är korrekt!
            """
    
    Scenario: Slack formatting of a notification
        Given that the team defaultteam uses Slack formatting in Swedish
         When the notification CorrectNotification for user Erik is formatted
         Then the formatted response is
            """
            Erik löste nian!
            """
