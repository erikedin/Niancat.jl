Feature: Users

    Scenario: Users on different teams with the same name
        Given a user Pamela in team Foo
          And a user Pamela in team Bar
         When the users are compared
         Then they are considered different