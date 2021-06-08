using Behavior
using Behavior.Gherkin
using Niancat.Languages
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: Incorrect, Correct, Rejected, PuzzleIs, GetPuzzle, NoPuzzleSet
using Niancat.Games

@when("the puzzle is set to {String}") do context, puzzle
    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    response = gamecommand(context[:game], user, SetPuzzle(puzzle))
    context[:response] = response
end

@when("a user asks for the puzzle") do context
    team = Team(1, "defaultteam", "")
    user = User(1, "name", "displayname", team)
    response = gamecommand(context[:game], user, GetPuzzle())
    context[:response] = response
end

@then("the puzzle response is {String}") do context, puzzle
    @expect context[:response] == PuzzleIs(puzzle)
end

@given("that no puzzle has been set") do context
    # No action needed, the game does not have a puzzle
    # set by default after construction.
end

@then("the game responds that no puzzle has been set") do context
    @expect context[:response] == NoPuzzleSet()
end

@then("it is rejected") do context
    @expect context[:response] isa Rejected
end