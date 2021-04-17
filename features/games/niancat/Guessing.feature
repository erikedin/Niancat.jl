Feature: Guessing words in Niancat

    Background: A Swedish dictionary of words
        Given a Swedish dictionary
            | DATORSPEL |
            | LEDARPOST |
            | PUSSGURKA |
            | ORDPUSSEL |
          And a new game

    Scenario: Not a word
        Given a puzzle ORDPUSSLE
         When a guess ORDPLUSSE is made
         Then the response is that the guess is wrong
    
    Scenario: Correct word
        Given a puzzle ORDPUSSLE
         When a guess ORDPUSSEL is made
         Then the response is that the word is correct

    Scenario Outline: Multiple correct solutions
        Given a puzzle DATORSPLE
         When a guess <word> is made
         Then the response is that the word is correct

        Examples:
            | word      |
            | DATORSPEL |
            | LEDARPOST |