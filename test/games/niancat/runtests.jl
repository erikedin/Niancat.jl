using Test
using Niancat.Gameface
import Niancat.Gameface: score!
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct, Rejected, NewPuzzle, NotAWord
using Niancat.Languages
using Niancat.Users

struct TestingGameService <: GameService
    scores::Vector{Tuple{User, Score}}

    TestingGameService() = new([])
end

Gameface.score!(tgs::TestingGameService, user::User, score::Score) = push!(tgs.scores, (user, score))

@testset "Niancat" begin
    include("guessing_test.jl")
    include("language_test.jl")
    include("setpuzzle_test.jl")
    include("score_test.jl")
end