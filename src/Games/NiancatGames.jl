module NiancatGames

using Niancat.AbstractGame
using Niancat.Languages
using Niancat.Users
using UUIDs
import Niancat.Core: gamecommand, gameinstanceid, gameround

struct SetPuzzle
    puzzle::String
end

struct Guess
    word::Word

    Guess(s::String) = new(Word(s))
end

struct GetPuzzle end

struct PuzzleIs <: Response
    puzzle::String
end

struct NoPuzzleSet <: Response end

struct Incorrect <: Response
    word::Word

    Incorrect(s::String) = new(Word(s))
end

struct Correct <: Response
    word::Word

    Correct(s::String) = new(Word(s))
end

struct Rejected <: Response end

struct NewPuzzle <: Response
    puzzle::String
end

struct NotAWord <: Response
    puzzle::String
end

mutable struct NiancatGame <: Game
    gameinstanceid::Int
    dictionary::SwedishDictionary
    puzzle::Union{Nothing, String}
    round::UUID

    NiancatGame(d::SwedishDictionary) = new(1, d, nothing, uuid4())
end

AbstractGame.gameround(game::NiancatGame) :: String = string(game.round)
AbstractGame.gameinstanceid(game::NiancatGame) :: Int = game.gameinstanceid

function AbstractGame.gamecommand(game::NiancatGame, ::User, setpuzzle::SetPuzzle) :: Response
    if game.puzzle !== nothing && isanagram(game.puzzle, setpuzzle.puzzle)
        return Rejected()
    end
    if findanagrams(game.dictionary, setpuzzle.puzzle) == []
        return Rejected()
    end
    game.puzzle = setpuzzle.puzzle
    NewPuzzle(game.puzzle)
end

function AbstractGame.gamecommand(game::NiancatGame, ::User, getpuzzle::GetPuzzle) :: Response
    if game.puzzle === nothing
        NoPuzzleSet()
    else
        PuzzleIs(game.puzzle)
    end
end

function AbstractGame.gamecommand(game::NiancatGame, ::User, guess::Guess) :: Response
    if guess.word.w in game.dictionary && isanagram(guess.word.w, game.puzzle)
        Correct(guess.word.w)
    else
        Incorrect(guess.word.w)
    end
end

export NiancatGame

end