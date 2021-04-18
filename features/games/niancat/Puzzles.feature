Feature: Setting a puzzle

    Background: A Swedish dictionary of words
        Given a Swedish dictionary
            | DATORSPEL |
            | LEDARPOST |
            | PUSSGURKA |
            | ORDPUSSEL |
          And a new game

    Scenario: Setting and getting the puzzle
        Given a puzzle ORDPUSSLE
         When a user asks for the puzzle
         Then the puzzle response is ORDPUSSLE
    
    Scenario: Setting a new puzzle
        Given a puzzle ORDPUSSLE
         When the puzzle is set to DATORSPLE
          And a user asks for the puzzle
         Then the puzzle response is DATORSPLE
    
    Scenario: No puzzle set
        Given that no puzzle has been set
         When a user asks for the puzzle
         Then the game responds that no puzzle has been set
    
    Scenario: Setting the same puzzle again
        Given a puzzle ORDPUSSLE
         When the puzzle is set to ORDPUSSLE
         Then it is rejected
    
    Scenario: Setting an anagram of the puzzle again
        Given a puzzle ORDPUSSLE
         When the puzzle is set to ORDPUSLES
         Then it is rejected
    
    @wip
    Scenario: Puzzle has no solutions
         When the puzzle is set to NOTAREALWORD
         Then it is rejected
         