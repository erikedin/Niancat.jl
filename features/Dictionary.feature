Feature: Dictionary
    These are features available to any dictionary.

    Background: A dictionary
        Given a Swedish dictionary
            | DATORSPEL |
            | LEDARPOST |
            | PUSSGURKA |
            | ORDPUSSEL |

    Scenario: Find anagrams
         When finding anagrams for DATORSPLE
         Then these words are found
            | DATORSPEL |
            | LEDARPOST |
    
    Scenario: No anagrams found
         When finding anagrams for NOSUCHWORD
         Then no words are found
    
    Scenario: Find words
         When seeing if PUSSGURKA is in the dictionary
         Then the answer is yes

    Scenario: Not finding words
         When seeing if NOSUCHWORD is in the dictionary
         Then the answer is no