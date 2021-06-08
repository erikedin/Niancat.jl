@testset "Scores; Guess is correct; User is given a point" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(gameservice.scores) == 1
    (actualuser, score) = gameservice.scores[1]
    @test user == actualuser
    @test score.value == 1
end

@testset "Scores; Guess is wrong; User is not given a point" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORLESP"))

    # Assert
    @test length(gameservice.scores) == 0
end

@testset "Scores; Guess same thing twice; Both scores events have the same key" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(gameservice.scores) == 2
    (_user1, score1) = gameservice.scores[1]
    (_user2, score2) = gameservice.scores[2]

    @test score1.key == score2.key
end

@testset "Scores; Guess two different solutions; The score events have different keys" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("LEDARPOST"))

    # Assert
    @test length(gameservice.scores) == 2
    (_user1, score1) = gameservice.scores[1]
    (_user2, score2) = gameservice.scores[2]

    @test score1.key != score2.key
end

@testset "Scores; Guess same thing twice with non-alphabetic differences; Both scores events have the same key" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATOR-SPEL"))
    gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(gameservice.scores) == 2
    (_user1, score1) = gameservice.scores[1]
    (_user2, score2) = gameservice.scores[2]

    @test score1.key == score2.key
end

@testset "Scores; Guess two different solutions; The score events have the same round" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("LEDARPOST"))

    # Assert
    @test length(gameservice.scores) == 2
    (_user1, score1) = gameservice.scores[1]
    (_user2, score2) = gameservice.scores[2]

    @test score1.round == score2.round
end

@testset "Scores; Score points in two different rounds; The score events have different rounds" begin
    # Arrange
    gameservice = TestingGameService()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST", "ORDPUSSEL"])
    game = NiancatGame(dictionary, gameservice)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)

    # Act
    gamecommand(game, user, SetPuzzle("DATORSPLE"))
    gamecommand(game, user, Guess("DATORSPEL"))

    gamecommand(game, user, SetPuzzle("ORDPUSSLE"))
    gamecommand(game, user, Guess("ORDPUSSEL"))

    # Assert
    @test length(gameservice.scores) == 2
    (_user1, score1) = gameservice.scores[1]
    (_user2, score2) = gameservice.scores[2]

    @test score1.round != score2.round
end