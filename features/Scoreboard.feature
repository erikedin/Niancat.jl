@scoreboard
Feature: Scoreboard

    Background: Setting up a game
        Given a game of Niancat in the default instance
          And a user Erik in the default team

    Scenario: Score a point
        Given a puzzle PUSSGURAK
         When Erik solves the puzzle with word PUSSGURKA
         Then Erik has score 1 in the scoreboard for Niancat
    
    Scenario: Score two points
        Given a puzzle DATORSPLE
         When Erik solves the puzzle with word DATORSPEL
          And Erik solves the puzzle with word LEDARPOST
         Then Erik has score 2 in the scoreboard for Niancat
    
    Scenario: Solutions are not counted more than once
        Given a puzzle DATORSPLE
         When Erik solves the puzzle with word DATORSPEL
          And Erik solves the puzzle with word DATORSPEL again
         Then Erik has score 1 in the scoreboard for Niancat
    
    Scenario: Scoreboard resets each round
        Given a puzzle PUSSGURAK
          And Erik solves the puzzle with word PUSSGURKA
         When the puzzle is set to ORDPUSSLE
         Then Erik is not in the scoreboard