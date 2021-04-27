using Behavior
using Niancat.Scores
using Niancat.Persistence

column(t::Gherkin.DataTable) = [row[1] for row in t]

@given("games") do context
    db = context[:db]

    gamenames = column(context.datatable)

    for gamename in gamenames
        addgame(db, gamename)
    end
end

@when("the user scores {Int} point") do context, point
    scoresdb = context[:db]
    user = context[:user]

    recordscore!(scoresdb, user, Score("Niancat", "round1", "defaultkey", point))
end

@when("the user scores {Int} point with score key {String}") do context, point, key
    scoresdb = context[:db]
    user = context[:user]

    recordscore!(scoresdb, user, Score("Niancat", "round1", key, point))
end

@then("the user has score {Int} on the scoreboard") do context, score
    scoresdb = context[:db]
    user = context[:user]

    @expect userscore(scoresdb, user) == score
end

@when("{String} scores {Int} points in game {String}") do context, username, points, gamename
    db = context[:db]
    users = context[:users]
    user = users[username]

    score = Score(gamename, "round1", "defaultkey", points)
    recordscore!(db, user, score)
end

@then("{String} has score {Int} on the scoreboard for {String}") do context, username, points, gamename
    db = context[:db]
    users = context[:users]
    user = users[username]

    scoreboard = getscoreboard(db, gamename)
    @expect userscore(scoreboard, user) == points
end