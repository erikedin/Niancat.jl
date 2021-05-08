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