Feature: Languages

    Background: 
        Given a game service
          And a dictionary "sv-14" with words
            | DATORSPEL |
            | LEDARPOST |
            | ORDPUSSEL |
          And a dictionary "en" with words
            | WORDPUZZLE |
            | NINE       |

    @wip
    Scenario: Reading a Swedish dictionary from disk
         When a dictionary with id "sv-14" is requested
         Then the dictionary has these words
            | DATORSPEL |
            | LEDARPOST |
            | ORDPUSSEL |
    
    @wip
    Scenario: Reading an English dictionary from disk
         When a dictionary with id "en" is requested
         Then the dictionary has these words
            | WORDPUZZLE |
            | NINE       |
          And the dictionary does not have these words
            | DATORSPEL |
            | LEDARPOST |
            | ORDPUSSEL |

    @wip
    Scenario: Non-existent dictionary
         When a dictionary with id "nosuchdictionary-00" is requested
         Then the dictionary is "nothing"
