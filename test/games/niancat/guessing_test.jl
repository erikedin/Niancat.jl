
@testset "Puzzle is DATORSPLE; User guesses DATORPLES; Guess is not a word" begin
    # Arrange
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, TestingGameService())
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORPLES"))

    # Assert
    @test response == Incorrect("DATORPLES")
end

@testset "Puzzle is DATORSPLE; User guesses DATORSPEL; Guess is correct" begin
    # Arrange
    dictionary = SwedishDictionary(["DATORSPEL"])
    game = NiancatGame(dictionary, TestingGameService())
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test response == Correct("DATORSPEL")
end

@testset "Puzzle is DATORSPLE; User guesses other solution LEDARPOST; Guess is correct" begin
    # Arrange
    dictionary = SwedishDictionary(["DATORSPEL", "LEDARPOST"])
    game = NiancatGame(dictionary, TestingGameService())
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("DATORSPLE"))

    # Act
    response = gamecommand(game, user, Guess("LEDARPOST"))

    # Assert
    @test response == Correct("LEDARPOST")
end

@testset "Puzzle is PUSSGRUKA; User guesses PUSSGURKA; Guess is correct" begin
    # Arrange
    dictionary = SwedishDictionary(["PUSSGURKA"])
    game = NiancatGame(dictionary, TestingGameService())
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

    # Act
    response = gamecommand(game, user, Guess("PUSSGURKA"))

    # Assert
    @test response == Correct("PUSSGURKA")
end

@testset "Puzzle is PUSSGRUKA; User guesses DATORSPEL; Guess is incorrect" begin
    # Arrange
    dictionary = SwedishDictionary(["DATORSPEL", "PUSSGURKA"])
    game = NiancatGame(dictionary, TestingGameService())
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    gamecommand(game, user, SetPuzzle("PUSSGRUKA"))

    # Act
    response = gamecommand(game, user, Guess("DATORSPEL"))

    # Assert
    @test response isa Incorrect
    @test response.word == Word("DATORSPEL")
end