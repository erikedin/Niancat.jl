import Niancat.Gameface: record!

struct MockGameEventPersistence <: GameEventPersistence
    scores::Vector{Tuple{User, Score}}

    MockGameEventPersistence() = new([])
end

function Gameface.record!(m::MockGameEventPersistence, user::User, score::Score)
    push!(m.scores, (user, score))
end

@testset "Scores; Guess is correct; User is given a point" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(m.scores) == 1
    (actualuser, score) = m.scores[1]
    @test user == actualuser
    @test score.value == 1
end

@testset "Scores; Guess is wrong; User is not given a point" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORLESP"))

    # Assert
    @test length(m.scores) == 0
end

@testset "Scores; Guess same thing twice; Both scores events have the same key" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(m.scores) == 2
    (_user1, score1) = m.scores[1]
    (_user2, score2) = m.scores[2]

    @test score1.key == score2.key
end

@testset "Scores; Guess two different solutions; The score events have different keys" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("LEDARPOST"))

    # Assert
    @test length(m.scores) == 2
    (_user1, score1) = m.scores[1]
    (_user2, score2) = m.scores[2]

    @test score1.key != score2.key
end

@testset "Scores; Guess same thing twice with non-alphabetic differences; Both scores events have the same key" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATOR-SPEL"))
    gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test length(m.scores) == 2
    (_user1, score1) = m.scores[1]
    (_user2, score2) = m.scores[2]

    @test score1.key == score2.key
end

@testset "Scores; Guess two different solutions; The score events have the same round" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    gamecommand(game, user, Guess("DATORSPEL"))
    gamecommand(game, user, Guess("LEDARPOST"))

    # Assert
    @test length(m.scores) == 2
    (_user1, score1) = m.scores[1]
    (_user2, score2) = m.scores[2]

    @test score1.round == score2.round
end

@testset "Scores; Score points in two different rounds; The score events have different rounds" begin
    # Arrange
    m = MockGameEventPersistence()
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST", "ORDPUSSEL"])
    game = NiancatGame(dictionary, m)

    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)

    # Act
    gamecommand(game, user, SetPuzzle("DATORSPLE"))
    gamecommand(game, user, Guess("DATORSPEL"))

    gamecommand(game, user, SetPuzzle("ORDPUSSLE"))
    gamecommand(game, user, Guess("ORDPUSSEL"))

    # Assert
    @test length(m.scores) == 2
    (_user1, score1) = m.scores[1]
    (_user2, score2) = m.scores[2]

    @test score1.round != score2.round
end