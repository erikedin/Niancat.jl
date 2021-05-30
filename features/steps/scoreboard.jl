using Behavior
using Niancat.Persistence
using Niancat.Instances
using Niancat.Games.NiancatGames
using Niancat.Languages
using Niancat.Scores
using SQLite

@given("a game of Niancat in the default instance") do context
    sqlitedb = SQLite.DB()

    service = NiancatService(sqlitedb)
    context[:service] = service

    context[:db] = service.persistence

    gi = service.instances

    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(service, "Niancat", (_state, gameservice) -> NiancatGame(dictionary, gameservice))

    loadgameinstances!(service)

    niancat = getgame(gi, "Niancat", "defaultinstance")
    context[:game] = niancat

end

@given("a user Erik in the default team") do context
    db = context[:db]

    user = getuser(db, "Erik", "defaultteam")
    context[:user] = user
end

@given("these users in the default team") do context
    db = context[:db]

    usernames = column(context.datatable)

    users = [getuser(db, username, "defaultteam")
             for username in usernames]
    context[:users] = users
end

@when("{String} solves the puzzle with word {String}") do context, username, word
    db = context[:db]
    user = getuser(db, username, "defaultteam")

    response = gamecommand(context[:game], user, Guess(word))
    context[:response] = response
end

@then("{String} has score {Int} in the scoreboard for Niancat") do context, username, points
    db = context[:db]
    user = getuser(db, username, "defaultteam")
    niancat = context[:game]

    scoreboard = getscoreboard(db, niancat)

    @expect userscore(scoreboard, user) == points
end

@then("{String} is not in the scoreboard") do context, username
    db = context[:db]
    user = getuser(db, username, "defaultteam")
    niancat = context[:game]

    scoreboard = getscoreboard(db, niancat)

    @expect hasuser(scoreboard, user) == false
end