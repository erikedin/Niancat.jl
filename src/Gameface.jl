module Gameface

using Niancat.Users

"""
Game represents a word game of some kind.

One can send commands to a `Game`, and get `Response`s.
"""
abstract type Game end

"""
Response represents a human-readable response to a player.
"""
abstract type Response end

"""
GameCommand represents any command sent to a game.
"""
abstract type GameCommand end

"""
GameNotification is a message not sent as a response to a game command.

# Example: A new puzzle
A new puzzle can be set directly in the service, by a system user, and not via a chat
channel like Slack or Discord. In this case, the game must notify the main channels for all teams
in that instance, that a new puzzle is set, along with the scoreboard for the previous round.
This is a notification, as it doesn't fit into the command/response flow.
"""
abstract type GameNotification end

"""
    gamecommand(game::Game, user::User, command::GameCommand) :: Response

`gamecommand` sends a command to a given game.
"""
gamecommand(::Game, ::User, ::GameCommand) :: Response = error("Implement this in Game subtypes")

"""
NoResponse is an empty response object, for when a command should not respond
with any message.
"""
struct NoResponse <: Response end

"""
    gameround(game::Game) :: String

The round identifier for the current round of the game instance `game`.
"""
gameround(::Game) :: String = error("Implement this in Game subtypes")

"""
    gameinstanceid(game::Game) :: Int

The database id for this instance of the game.
"""
gameinstanceid(::Game) :: Int = error("Implement this in Game subtypes")

"""
GameEventPersistence records game events, like scores.
"""
abstract type GameEventPersistence end

"""
Score represents a score for a given round of a game.
"""
struct Score
    gameinstanceid::Int
    round::String
    key::String
    value::Float32
end

"""
InstanceInfo encapsulates static, but not dynamic, information on an instance.

# Example
Instance name, and instance database id.

Does not contain dynamic information, such as which teams belong to an instance.

# Limitations
Note that this implementation implies that instances cannot easily be renamed, as you would have
to update the `instanceinfo` member on the `GameService` struct, which is immutable.
The rename would only take full effect after game instances were reloaded.
"""
struct InstanceInfo
    databaseid::Int
    name::String
end

"""
GameService is an interface between the games and the service.
Each game instance has its own GameService object.

For example, sending notifications to users from a game is done via the GameService.
Recording user scores is done via the GameService.
"""
abstract type GameService end

score!(::GameService, ::User, ::Score) = error("Implement this in GameService subtypes")

"""
ConcreteGameService is merely the implementation of the `GameService` interface.
The interface is abstract for testing purposes.
"""
struct ConcreteGameService <: GameService
    instanceinfo::InstanceInfo
    gameinstanceid::Int
    persistence::GameEventPersistence
end

export Game, Response, NoResponse, gamecommand, gameinstanceid, gameround, Score, score!, GameEventPersistence
export GameCommand
export GameService, InstanceInfo, ConcreteGameService

end