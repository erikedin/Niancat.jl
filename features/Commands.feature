Feature: Game commands

    Background: A Niancat game
        Given a default Niancat service
          And a user Erik in the default team

    Scenario: A Niancat command
         When Erik sends the command "!nian"
         Then the service finds the game Niancat in the default instance
          And the command is GetPuzzle()

    Scenario: A Niancat command
        Given a puzzle ORDPUSSLE
         When Erik sends the command "ORDPUSSEL"
         Then the service finds the game Niancat in the default instance
          And the command is Guess("ORDPUSSEL")

    Scenario: Niancat: Set the puzzle
         When Erik sends the command "!sättnian ORDPUSSLE"
         Then the service finds the game Niancat in the default instance
          And the command is SetPuzzle("ORDPUSSLE")