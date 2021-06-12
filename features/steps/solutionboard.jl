using Behavior
using Niancat.Persistence
using Niancat.Instances
using Niancat.Games.NiancatGames
using Niancat.Languages
using Niancat.Scores

@then("the solution board lists {String} as solving {String}") do context, username, word
    game = context[:game]
    db = context[:db]
    dictionary = context[:dictionary]

    board = getsolutionboard(db, gameinstanceid(game), gameround(game))

    users = board.solutions[normalizedword(dictionary, word)]
    expecteduser = getuser(db, username, "defaultteam")

    @expect expecteduser in users
end

@then("the solution board does not list {String} as solving {String}") do context, username, word
    game = context[:game]
    db = context[:db]
    dictionary = context[:dictionary]

    board = getsolutionboard(db, gameinstanceid(game), gameround(game))

    users = board.solutions[normalizedword(dictionary, word)]
    expecteduser = getuser(db, username, "defaultteam")

    @expect !(expecteduser in users)
end