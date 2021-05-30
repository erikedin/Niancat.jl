Feature: Solutions
    The solution board shows who solved which puzzle in a given round.

    Background: Setting up a game
        Given a game of Niancat in the default instance
          And these users in the default team
            | Erik    |
            | Jenna   |

    Scenario: Showing a user solving a puzzle
        Given a puzzle PUSSGURAK
         When Erik solves the puzzle with word PUSSGURKA
         Then the solution board lists Erik as solving PUSSGURKA

    Scenario: Showing a user solving both solutions for a puzzle
        Given a puzzle DATORSPLE
         When Erik solves the puzzle with word DATORSPEL
          And Erik solves the puzzle with word LEDARPOST
         Then the solution board lists Erik as solving DATORSPEL
          And the solution board lists Erik as solving LEDARPOST

    Scenario: Showing a user solving only one solution
        Given a puzzle DATORSPLE
         When Erik solves the puzzle with word DATORSPEL
         Then the solution board lists Erik as solving DATORSPEL
          And the solution board does not list Erik as solving LEDARPOST

    Scenario: Showing a user solving only one solution
        Given a puzzle DATORSPLE
         When Erik solves the puzzle with word DATORSPEL
         Then the solution board lists Erik as solving DATORSPEL
          And the solution board does not list Erik as solving LEDARPOST

    Scenario: Showing two users solving a puzzle
        Given a puzzle PUSSGURAK
         When Erik solves the puzzle with word PUSSGURKA
          And Jenna solves the puzzle with word PUSSGURKA
         Then the solution board lists Erik as solving PUSSGURKA
          And the solution board lists Jenna as solving PUSSGURKA