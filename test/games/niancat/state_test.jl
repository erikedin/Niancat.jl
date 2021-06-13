using UUIDs

@testset "Niancat game state" begin
    @testset "State has puzzle PUSSGUKRA; Get the puzzle; Puzzle is PUSSGUKRA" begin
        # Arrange
        round = uuid4()
        state = "PUSSGUKRA#sv-14#$(round)"
        game = NiancatGame(state, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        response = gamecommand(game, user, GetPuzzle())

        # Assert
        @test response == PuzzleIs("PUSSGUKRA")
    end

    @testset "State has a given round; Get the game round; The round is same as the state" begin
        # Arrange
        round = uuid4()
        state = "PUSSGUKRA#sv-14#$(round)"
        game = NiancatGame(state, TestingGameService())

        # Act
        actualround = gameround(game)

        # Assert
        @test string(round) == actualround
    end

    @testset "State has dictionary sv-14; Requests dictionary sv-14" begin
        # Arrange
        round = uuid4()
        state = "PUSSGUKRA#sv-14#$(round)"
        gameservice = TestingGameService()

        # Act
        game = NiancatGame(state, gameservice)

        # Assert
        @test gameservice.dictionaryrequests == ["sv-14"]
    end

    @testset "State has dictionary en-00; Requests dictionary en-00" begin
        # Arrange
        round = uuid4()
        state = "PUSSGUKRA#en-00#$(round)"
        gameservice = TestingGameService()

        # Act
        game = NiancatGame(state, gameservice)

        # Assert
        @test gameservice.dictionaryrequests == ["en-00"]
    end
end