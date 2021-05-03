using Test
using Niancat.Gameface
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct, Rejected, NewPuzzle, NotAWord
using Niancat.Languages
using Niancat.Users

@testset "Niancat" begin
    include("guessing_test.jl")
    include("language_test.jl")
    include("setpuzzle_test.jl")
end