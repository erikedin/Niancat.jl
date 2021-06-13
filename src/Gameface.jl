module Gameface

using Niancat.Users
using Niancat.Http

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

struct GameUserEvent
    eventtype::Int
    user::User
    round::String
    data::String
end

const UserEvent_Solution = 1
const GameEvent_Solution = 1

struct GameEvent
    eventtype::Int
    round::String
    data::String
end

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

The default implementation assumes that the game has a field `gameservice`
of type `GameService`, from which it can find the game instance id.
"""
gameinstanceid(g::Game) :: Int = gameinstanceid(g.gameservice)

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
GameEventPersistence records game events, like scores.
"""
abstract type GameEventPersistence end

score!(::GameEventPersistence, ::User, ::Score) = error("Implement this in GameEventPersistence subtypes")


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

abstract type LanguageDictionary end

"""
GameService is an interface between the games and the service.
Each game instance has its own GameService object.

For example, sending notifications to users from a game is done via the GameService.
Recording user scores is done via the GameService.
"""
abstract type GameService end

score!(::GameService, ::User, ::Score) = error("Implement score! in GameService subtypes")
notify!(::GameService, ::GameNotification) = error("Implement notify! in GameService subtypes")
event!(::GameService, ::GameUserEvent) = error("Implement event! for GameUserEvent in GameService subtypes")
event!(::GameService, ::GameEvent) = error("Implement event! for GameEvent in GameService subtypes")
finddictionary(::GameService, ::AbstractString) = error("Implement finddictionary in GameService subtypes")


##
## Exports
##

export Game, Response, NoResponse, gamecommand, gameinstanceid, gameround, Score, GameEventPersistence
export GameCommand, GameNotification
export InstanceInfo

# GameService export
export GameService, score!, notify!, finddictionary

# Events
export event!, GameUserEvent, GameEvent

# LanguageDictionary
export LanguageDictionary

end