Feature: Guessing words in Niancat

    Background: A Swedish dictionary of words
        Given a dictionary
            | DATORSPEL |
            | LEDARPOST |
            | PUSSGURKA |
            | ORDPUSSEL |

    @wip
    Scenario: Not a word
        Given a puzzle DATORSPLE
         When a guess DATORPLES is made
         Then the response is that the guess is wrong
    
    @wip
    Scenario: Correct word
        Given a puzzle DATORSPLE
         When a guess DATORSPEL is made
         Then the response is that the word is correct