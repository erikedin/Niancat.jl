@testset "Setting the puzzle" begin
    @testset "Puzzle is ORDPUSSLE; Setting ORDPUSSLE again; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle is ORDPUSSLE; Setting the puzzle to DATORSPLE; Allowed" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL", "DATORSPEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Assert
        @test response == NewPuzzle("DATORSPLE")
    end

    @testset "Puzzle is ORDPUSSLE; Setting the anagram ORDPUSLES; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSLES"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle is ORDPUSSLE; Setting the non-normal ordpusles; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary)
        user = User("name")
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ordpusles"))

        # Assert
        @test response isa Rejected
    end
end