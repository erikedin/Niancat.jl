using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct, Rejected, NewPuzzle, GetPuzzle, PuzzleIs, NoPuzzleSet
using Niancat.Games.NiancatGames: CorrectNotification
using Niancat.Languages

@testset "Niancat" begin
    include("guessing_test.jl")
    include("language_test.jl")
    include("setpuzzle_test.jl")
    include("score_test.jl")
    include("state_test.jl")
end