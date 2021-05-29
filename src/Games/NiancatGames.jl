module NiancatGames

using Niancat.Gameface
using Niancat.Languages
using Niancat.Users
using Niancat.Scores
import Niancat.Gameface: gamecommand
using UUIDs

#
# Commands
#

struct SetPuzzle <: GameCommand
    puzzle::String
end

struct Guess <: GameCommand
    word::Word

    Guess(s::String) = new(Word(s))
end

struct GetPuzzle <: GameCommand end

#
# Command responses
#

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

#
# Notifications
#

struct CorrectNotification <: GameNotification
    user::User
end

#
# Game logic
#

mutable struct NiancatGame <: Game
    gameservice::GameService
    round::UUID
    dictionary::SwedishDictionary
    puzzle::Union{Nothing, String}

    NiancatGame(d::SwedishDictionary, gameservice::GameService) = new(gameservice, uuid4(), d, nothing)
end

Gameface.gameround(game::NiancatGame) :: String = string(game.round)

function Gameface.gamecommand(game::NiancatGame, ::User, setpuzzle::SetPuzzle) :: Response
    if game.puzzle !== nothing && isanagram(game.puzzle, setpuzzle.puzzle)
        return Rejected()
    end
    if findanagrams(game.dictionary, setpuzzle.puzzle) == []
        return Rejected()
    end
    game.puzzle = setpuzzle.puzzle
    game.round = uuid4()
    NewPuzzle(game.puzzle)
end

function Gameface.gamecommand(game::NiancatGame, ::User, getpuzzle::GetPuzzle) :: Response
    if game.puzzle === nothing
        NoPuzzleSet()
    else
        PuzzleIs(game.puzzle)
    end
end

function Gameface.gamecommand(game::NiancatGame, user::User, guess::Guess) :: Response
    if guess.word.w in game.dictionary && isanagram(guess.word.w, game.puzzle)
        score!(game.gameservice, user, Score(1, string(game.round), normalizedword(game.dictionary, guess.word.w), 1))
        notify!(game.gameservice, CorrectNotification(user))
        Correct(guess.word.w)
    else
        Incorrect(guess.word.w)
    end
end

export NiancatGame

end