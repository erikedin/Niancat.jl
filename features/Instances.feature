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
            | Quux            |
            | Fnord           |
    
    @wip
    Scenario: A team updates its notification endpoint
        Given that the team defaultteam updates the notification endpoint to http://localhost:8081/notification
         When a notification is sent for the instance defaultinstance
         Then the notification is sent to http://localhost:8001/notification