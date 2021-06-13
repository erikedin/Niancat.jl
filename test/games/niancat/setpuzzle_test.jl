@testset "Setting the puzzle" begin
    @testset "Puzzle is ORDPUSSLE; Setting ORDPUSSLE again; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle is ORDPUSSLE; Setting the puzzle to DATORSPLE; Allowed" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL", "DATORSPEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Assert
        @test response == NewPuzzle("DATORSPLE")
    end

    @testset "Puzzle is ORDPUSSLE; Setting the anagram ORDPUSLES; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSLES"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle is ORDPUSSLE; Setting the non-normal ordpusles; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Act
        response = gamecommand(game, user, SetPuzzle("ordpusles"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle has no solutions; Rejected" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Assert
        @test response isa Rejected
    end

    @testset "Puzzle is rejected because of no solutions; The round is still the same" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))
        roundbefore = gameround(game)

        # Act
        gamecommand(game, user, SetPuzzle("NOSUCHWORD"))
        roundafter = gameround(game)

        # Assert
        @test roundbefore == roundafter
    end

    @testset "Puzzle is ORDPUSSLE; Setting the anagram ORDPUSLES; The round is unchanged" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))
        roundbefore = gameround(game)

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSLES"))
        roundafter = gameround(game)

        # Assert
        @test roundbefore == roundafter
    end

    @testset "Puzzle is ORDPUSSLE; Setting the puzzle to DATORSPLE; The round is changed" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL", "DATORSPEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("ORDPUSSLE"))
        roundbefore = gameround(game)

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))
        roundafter = gameround(game)

        # Assert
        @test roundbefore != roundafter
    end

    @testset "Setting the puzzle to PUSSGUKRA; One solution; One solution event sent" begin
        # Arrange
        dictionary = SwedishDictionary(["PUSSGURKA"])
        gameservice = TestingGameService()
        game = NiancatGame(dictionary, gameservice)
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        response = gamecommand(game, user, SetPuzzle("PUSSGUKRA"))

        # Assert
        @test length(gameservice.gameevents) != 0
        event = lastgameevent(gameservice)
        @test event.eventtype == Gameface.GameEvent_Solution
        @test event.round == gameround(game)
        @test event.data == normalizedword(dictionary, "PUSSGURKA")
    end

    @testset "Setting the puzzle to DATORSPLE; Two solutions; Two solution events sent" begin
        # Arrange
        dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
        gameservice = TestingGameService()
        game = NiancatGame(dictionary, gameservice)
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Assert
        @test length(gameservice.gameevents) >= 2
        solutions = [event.data
                     for event in gameservice.gameevents
                     if event.eventtype == Gameface.GameEvent_Solution]
        sortedsolutions = sort(solutions)
        @test sortedsolutions == ["datorspel", "ledarpost"]
    end

    @testset "Puzzle is not set; Setting ORDPUSSLE; NewPuzzle response sent" begin
        # Arrange
        dictionary = SwedishDictionary(["ORDPUSSEL"])
        game = NiancatGame(dictionary, TestingGameService())
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        response = gamecommand(game, user, SetPuzzle("ORDPUSSLE"))

        # Assert
        @test response isa NewPuzzle
    end

    @testset "Puzzle is PUSSGUKRA; Setting a new puzzle DATORSPLE; A solution board notification is sent" begin
        # Arrange
        gameservice = TestingGameService()
        dictionary = SwedishDictionary(["PUSSGURKA", "DATORSPEL"])
        game = NiancatGame(dictionary, gameservice)
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)
        gamecommand(game, user, SetPuzzle("PUSSGRUKA"))
        instanceid = gameinstanceid(game)
        round = gameround(game)

        # Act
        response = gamecommand(game, user, SetPuzzle("DATORSPLE"))
        # Precondition: Response is a NewPuzzle
        @test response isa NewPuzzle

        # Assert
        @test length(gameservice.notifications) != 0
        @test SolutionboardNotification(instanceid, round) in gameservice.notifications
    end

    @testset "No puzzle is set; Setting a new puzzle DATORSPLE; No solution board notification is sent" begin
        # Arrange
        gameservice = TestingGameService()
        dictionary = SwedishDictionary(["PUSSGURKA", "DATORSPEL"])
        game = NiancatGame(dictionary, gameservice)
        team = Team(1, "defaultteam", "")
        user = User(1, "name", "displayname", team)

        # Act
        gamecommand(game, user, SetPuzzle("DATORSPLE"))

        # Assert
        @test !any(x -> x isa SolutionboardNotification, gameservice.notifications)
    end
end