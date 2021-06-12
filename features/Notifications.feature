Feature: Notifications

    Background: A service
        Given a default Niancat service
          And these users in the default team
            | Erik    |
            | Jenna   |

    Scenario: A solution board notification
        Given a puzzle DATORSPLE
          And Erik solves the puzzle with word DATORSPEL
          And Jenna solves the puzzle with word DATORSPEL
         When a solution board notification is sent for the current round
         Then a notification is sent, containing words
              | DATORSPEL |
              | Erik      |
              | Jenna     |

    @wip
    Scenario: Scoreboard notification
        Given a puzzle DATORSPLE
          And Erik solves the puzzle with word DATORSPEL
          And Jenna solves the puzzle with word DATORSPEL
         When a score board notification is sent for the current round
         Then a notification is sent, containing words
              | DATORSPEL |
              | Erik      |
              | Jenna     |