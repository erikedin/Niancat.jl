@testset "Language" begin
    @testset "Case-insensitivity" begin
        @testset "Puzzle is pussgruka; User guesses PUSSGURKA; Guess is correct" begin
            # Arrange
            dictionary = SwedishDictionary(["pussgurka"])
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
            gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

            # Act
            response = gamecommand(game, user, Guess("PUSSGURKA"))

            # Assert
            @test response == Correct("PUSSGURKA")
        end

        @testset "Puzzle is PUSSGRUKA; User guesses pussgurka; Guess is correct" begin
            # Arrange
            dictionary = SwedishDictionary(["PUSSGURKA"])
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
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
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
            gamecommand(game, user, SetPuzzle("Å"))

            # Act
            response = gamecommand(game, user, Guess("Å"))

            # Assert
            @test response == Correct("Å")
        end

        @testset "Swedish Å doesn't match A" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
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
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
            gamecommand(game, user, SetPuzzle("ÄR"))

            # Act
            response = gamecommand(game, user, Guess("ÄR"))

            # Assert
            @test response == Correct("ÄR")
        end

        @testset "Swedish ÄR doesn't match AR" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
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
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
            gamecommand(game, user, SetPuzzle("Ö"))

            # Act
            response = gamecommand(game, user, Guess("Ö"))

            # Assert
            @test response == Correct("Ö")
        end

        @testset "Swedish Ö doesn't match O" begin
            # Arrange
            dictionary = SwedishDictionary(["Å", "ÄR", "Ö"])
            game = NiancatGame(dictionary, TestingGameService())
            team = Team(1, "defaultteam", "")
            user = User(1, "name", team)
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
                game = NiancatGame(dictionary, TestingGameService())
                team = Team(1, "defaultteam", "")
                user = User(1, "name", team)
                gamecommand(game, user, SetPuzzle("DATORSPLE"))

                # Act
                response = gamecommand(game, user, Guess(word))

                # Assert
                @test response == Correct(word)
            end
        end
    end
end