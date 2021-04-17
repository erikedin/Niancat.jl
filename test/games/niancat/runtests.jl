using Test
using Niancat.Games
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: SetPuzzle, Guess, Incorrect, Correct
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

    @testset "Puzzle is DATORSPLE; User guesses DATORSPEL; Guess is correct" begin
        # Arrange
        dictionary = SwedishDictionary(["DATORSPEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Act
        response = gamecommand(game, user, Guess("DATORSPEL"))

        # Assert
        @test response == Correct("DATORSPEL")
    end

    @testset "Puzzle is DATORSPLE; User guesses other solution LEDARPOST; Guess is correct" begin
        # Arrange
        dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Act
        response = gamecommand(game, user, Guess("LEDARPOST"))

        # Assert
        @test response == Correct("LEDARPOST")
    end

    @testset "Puzzle is PUSSGRUKA; User guesses PUSSGURKA; Guess is correct" begin
        # Arrange
        dictionary = SwedishDictionary(["PUSSGURKA"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

        # Act
        response = gamecommand(game, user, Guess("PUSSGURKA"))

        # Assert
        @test response == Correct("PUSSGURKA")
    end

    @testset "Puzzle is PUSSGRUKA; User guesses DATORSPEL; Guess is incorrect" begin
        # Arrange
        dictionary = SwedishDictionary(["DATORSPEL", "PUSSGURKA"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

        # Act
        response = gamecommand(game, user, Guess("DATORSPEL"))

        # Assert
        @test response isa Incorrect
        @test response.word == Word("DATORSPEL")
    end

    @testset "Case-insensitivity" begin
        @testset "Puzzle is pussgruka; User guesses PUSSGURKA; Guess is correct" begin
            # Arrange
            dictionary = SwedishDictionary(["pussgurka"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

            # Act
            response = gamecommand(game, user, Guess("PUSSGURKA"))

            # Assert
            @test response == Correct("PUSSGURKA")
        end

        @testset "Puzzle is PUSSGRUKA; User guesses pussgurka; Guess is correct" begin
            # Arrange
            dictionary = SwedishDictionary(["PUSSGURKA"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

            # Act
            response = gamecommand(game, user, Guess("pussgurka"))

            # Assert
            @test response == Correct("pussgurka")
        end
    end
end