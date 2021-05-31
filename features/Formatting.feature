Feature: Formatting messages

    Background: A Niancat game
        Given a game of Niancat in the default instance

    Scenario: Slack formatting
        Given that the team defaultteam uses Slack formatting in Swedish
         When we format a Correct("PUSSGURKA") response
         Then the formatted response is
            """
            Ordet PUSSGURKA är korrekt!
            """