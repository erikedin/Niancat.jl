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
    gamecommand(game::Game, user::User, command::GameCommand) :: Response

`gamecommand` sends a command to a given game.
"""
gamecommand(::Game, ::User, ::GameCommand) :: Response = error("Implement this in Game subtypes")

"""
NoResponse is an empty response object, for when a command should not respond
with any message.
"""
struct NoResponse <: Response end

export Game, Response, NoResponse, gamecommand