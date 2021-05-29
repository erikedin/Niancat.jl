using Test
using Niancat.Gameface
import Niancat.Gameface: score!
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct, Rejected, NewPuzzle, NotAWord
using Niancat.Games.NiancatGames: CorrectNotification
using Niancat.Languages
using Niancat.Users

struct TestingGameService <: GameService
    scores::Vector{Tuple{User, Score}}
    notifications::Vector{GameNotification}

    TestingGameService() = new([], [])
end

Gameface.score!(tgs::TestingGameService, user::User, score::Score) = push!(tgs.scores, (user, score))
Gameface.notify!(tgs::TestingGameService, notification::GameNotification) = push!(tgs.notifications, notification)

lastnotification(tgs::TestingGameService) = tgs.notifications[end]

@testset "Niancat" begin
    include("guessing_test.jl")
    include("language_test.jl")
    include("setpuzzle_test.jl")
    include("score_test.jl")
end