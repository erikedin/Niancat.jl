using Test
using Niancat.Gameface
import Niancat.Gameface: record!
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct, Rejected, NewPuzzle, NotAWord
using Niancat.Languages
using Niancat.Users

struct NoopGameEventPersistence <: GameEventPersistence end
Gameface.record!(::NoopGameEventPersistence, ::User, ::Score) = nothing

@testset "Niancat" begin
    include("guessing_test.jl")
    include("language_test.jl")
    include("setpuzzle_test.jl")
    include("score_test.jl")
end