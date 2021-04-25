@wip
Feature: Scores

    Background: Score persistence
        Given a database for scores

    Scenario: Scoring a point
        Given a user with name Erik
         When the user scores 1 point
         Then the user has score 1 on the scoreboard

    Scenario: Different score keys
        Given a user with name Erik
         When the user scores 1 point with score key foo
          And the user scores 1 point with score key bar
         Then the user has score 2 on the scoreboard

    Scenario: Scores for the same keys are not counted twice
        Given a user with name Erik
         When the user scores 1 point with score key foo
          And the user scores 1 point with score key foo
         Then the user has score 1 on the scoreboard
    
    Scenario: Scores for different games
        Given a user with name Erik
         When Erik scores 3 points in game Quux
          And Erik scores 7 points in game Fnord
         Then Erik has score 3 on the scoreboard for Quux
          And Erik has score 7 on the scoreboard for Fnord
    
    Scenario: Scores for different rounds
        Given a user with name Erik
         When Erik scores 17 points in round 1
          And Erik scores 42 points in round 2
         Then Erik has score 17 on the scoreboard for round 1
          And Erik has score 42 on the scoreboard for round 2

    Scenario: Scores for the same round
        Given a user with name Erik
         When Erik scores 3 points in round 1
          And Erik scores 11 points in round 1
         Then Erik has score 14 on the scoreboard for round 1