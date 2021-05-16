Feature: Persistence

    Scenario: A new database is initialized
        Given a new database file
         When a Niancat service is started
         Then the database has the default tables
            | instances     |
            | teams         |
            | games         |
            | gameinstances |
            | users         |
            | scores        |

    Scenario: Instances are persisted
        Given an existing database file
          And that we add instances
            | Fnord |
            | Quux  |
         When a Niancat service is started
          And all instances are listed
         Then the listed instances are
            | Fnord           |
            | Quux            |
            | defaultinstance |
