Feature: Guessing words in Niancat

    Scenario: Not a word
        Given that the puzzle is DATORSPLE
         When the user guesses DATORPLES
         Then the response is that the word is not in the dictionary
    
    Scenario: Correct word
        Given that the puzzle is DATORSPLE
         When the user guesses DATORSPEL
         Then the response is that the solution is correct