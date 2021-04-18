using ExecutableSpecifications
using ExecutableSpecifications.Gherkin
using Niancat.Languages
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: Incorrect, Correct, Rejected
using Niancat.Games

@given("") do context
    @fail "Implement me"
end

@when("") do context
    @fail "Implement me"
end

@then("") do context
    @fail "Implement me"
end

@when("the puzzle is set to {String}") do context, puzzle
    response = gamecommand(context[:game], User("name"), SetPuzzle(puzzle))
    context[:response] = response
end

@when("a user asks for the puzzle") do context
    @fail "Not implemented"
end

@then("the puzzle response is {String}") do context, puzzle
    @fail "Not implemented"
end

@given("that no puzzle has been set") do context
    # No action needed, the game does not have a puzzle
    # set by default after construction.
end

@then("the game responds that no puzzle has been set") do context
    @fail "Not implemented"
end

@then("it is rejected") do context
    @expect context[:response] isa Rejected
end