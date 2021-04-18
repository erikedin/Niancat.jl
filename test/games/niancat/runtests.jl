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

    @testset "Diacritics" begin
        @testset "Swedish Å" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("Å"))

            # Act
            response = gamecommand(game, user, Guess("Å"))

            # Assert
            @test response == Correct("Å")
        end

        @testset "Swedish Å doesn't match A" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("Å"))

            # Act
            response = gamecommand(game, user, Guess("A"))

            # Assert
            @test response isa Incorrect
            @test response.word == Word("A")
        end

        @testset "Swedish ÄR" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("ÄR"))

            # Act
            response = gamecommand(game, user, Guess("ÄR"))

            # Assert
            @test response == Correct("ÄR")
        end

        @testset "Swedish ÄR doesn't match AR" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("ÄR"))

            # Act
            response = gamecommand(game, user, Guess("AR"))

            # Assert
            @test response isa Incorrect
            @test response.word == Word("AR")
        end

        @testset "Swedish Ö" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("Ö"))

            # Act
            response = gamecommand(game, user, Guess("Ö"))

            # Assert
            @test response == Correct("Ö")
        end

        @testset "Swedish Ö doesn't match O" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary)
            user = User("name")
            gamecommand(game, user, SetPuzzle("Ö"))

            # Act
            response = gamecommand(game, user, Guess("O"))

            # Assert
            @test response isa Incorrect
            @test response.word == Word("O")
        end

    end

    @testset "Non-alphabetic characters" begin
        withnonalpha = ["DATOR-SPEL", "DATOR SPEL", "DATOR_SPEL", "DATORSPEL:"]
        for word in withnonalpha
            @testset "Word $word matches puzzle DATORSPLE" begin
                # Arrange
                dictionary = SwedishDictionary(["DATORSPEL"])
                game = NiancatGame(dictionary)
                user = User("name")
                gamecommand(game, user, SetPuzzle("DATORSPLE"))

                # Act
                response = gamecommand(game, user, Guess(word))

                # Assert
                @test response == Correct(word)
            end
        end
    end
end