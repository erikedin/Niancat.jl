using Behavior
using Niancat.Persistence
using Niancat.Instances
using Niancat.Games.NiancatGames
using Niancat.Languages
using Niancat.Scores

@given("a game of Niancat in the default instance") do context
    db = GamePersistence()
    context[:db] = db

    gi = GameInstances()

    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(gi, "Niancat", (_state) -> NiancatGame(dictionary, db))

    loadgameinstances!(gi, db)

    niancat = getgame(gi, "Niancat", "defaultinstance")
    context[:game] = niancat

    service = NiancatService(db)
    context[:service] = service
end

@given("a user Erik in the default team") do context
    db = context[:db]

    user = getuser(db, "Erik", "defaultteam")
    context[:user] = user
end

@when("Erik solves the puzzle with word {String}") do context, word
    user = context[:user]

    response = gamecommand(context[:game], user, Guess(word))
    context[:response] = response
end

@then("Erik has score {Int} in the scoreboard for Niancat") do context, points
    user = context[:user]
    niancat = context[:game]
    db = context[:db]

    scoreboard = getscoreboard(db, niancat)

    @expect userscore(scoreboard, user) == points
end

@then("Erik is not in the scoreboard") do context
    user = context[:user]
    niancat = context[:game]
    db = context[:db]

    scoreboard = getscoreboard(db, niancat)

    @expect hasuser(scoreboard, user) == false
end