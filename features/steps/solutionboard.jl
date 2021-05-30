using Behavior
using Niancat.Persistence
using Niancat.Instances
using Niancat.Games.NiancatGames
using Niancat.Languages
using Niancat.Scores

@then("the solution board lists {String} as solving {String}") do context, username, word
    game = context[:game]
    db = context[:db]

    board = getsolutionboard(game, gameround(game))

    users = board.solutions[word]
    expecteduser = getuser(db, username, "defaultteam")

    @expect expecteduser in users
end