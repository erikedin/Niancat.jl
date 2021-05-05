using Behavior
using Niancat.Persistence

@given("a game of Niancat in the default instance") do context
    db = GamePersistence()
    context[:db] = db

    loadgameinstances!(db)

    niancat = getgame("Niancat", "defaultinstance")
    context[:game] = niancat
end

@given("a user Erik in the default team") do context
    db = context[:db]

    user = getuser(db, "Erik", "defaultteam")
    context[:user] = user
end

@when("Erik solves the puzzle with word {String}") do context, word
    @fail "Implement me"
end

@then("Erik has score {Int} in the scoreboard for Niancat") do context, points
    user = context[:user]
    niancat = context[:game]

    scoreboard = getscoreboard(db, niancat)

    @expect userscore(scoreboard, user) == points
end