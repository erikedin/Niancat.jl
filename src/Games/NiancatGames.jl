module NiancatGames

using Niancat.Games
using Niancat.Languages
using Niancat.Users
import Niancat.Games: gamecommand

struct SetPuzzle
    SetPuzzle(::String) = new()
end

struct Guess
    Guess(::String) = new()
end

struct Incorrect <: Response
    Incorrect(::String) = new()
end

struct NiancatGame <: Game
    NiancatGame(::SwedishDictionary) = new()
end

gamecommand(::NiancatGame, ::User, ::SetPuzzle) = nothing
gamecommand(::NiancatGame, ::User, ::Guess) = Incorrect("DATORPLES")

export NiancatGame

end