Feature: Instances

    Background: A default service
        Given a default Niancat service

    Scenario: The default instance
        Given that we add no instances
         When all instances are listed
         Then the listed instances are
            | defaultinstance |

    Scenario: Add instances
        Given that we add instances
            | Quux  |
            | Fnord |
         When all instances are listed
         Then the listed instances are
            | defaultinstance |
            | Quux  |
            | Fnord |