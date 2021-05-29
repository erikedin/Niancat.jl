using Behavior
using Behavior.Gherkin
using Niancat.Languages
using Niancat.Games.NiancatGames
using Niancat.Games.NiancatGames: Incorrect, Correct
using Niancat.Games
import Niancat.Gameface: score!

struct ByColumnTable
    table::Gherkin.DataTable
end

column(t::ByColumnTable, n::Int = 1) = [row[n] for row in t.table]

@given("a Swedish dictionary") do context
    table = ByColumnTable(context.datatable)
    words = column(table)
    context[:dictionary] = SwedishDictionary(words)
end

@given("a new game") do context
    dictionary = context[:dictionary]
    game = NiancatGame(dictionary, TestingGameService())
    context[:game] = game
end

@given("a puzzle {String}") do context, puzzle
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    response = gamecommand(context[:game], user, SetPuzzle(puzzle))
    context[:response] = response
end


@when("a guess {String} is made") do context, word
    team = Team(1, "defaultteam", "")
    user = User(1, "name", team)
    response = gamecommand(context[:game], user, Guess(word))
    context[:response] = response
end


@then("the response is that the guess is wrong") do context
    @expect context[:response] isa Incorrect
end


@then("the response is that the word is correct") do context
    @expect context[:response] isa Correct
end