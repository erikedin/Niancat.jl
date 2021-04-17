using Test
using Niancat.Games
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect
using Niancat.Languages
using Niancat.Users

@testset "Niancat" begin
    @testset "Puzzle is DATORSPLE; User guesses DATORPLES; Guess is not a word" begin
        # Arrange
        dictionary = SwedishDictionary(["DATORSPEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Act
        response = gamecommand(game, user, Guess("DATORPLES"))

        # Assert
        @test response == Incorrect("DATORPLES")
    end
end