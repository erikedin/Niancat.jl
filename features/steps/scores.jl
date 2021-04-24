using Behavior
using Niancat.Scores

@given("a database for scores") do context
    db = ScoresDatabase()
    context[:scoresdb] = db
    initialize!(db)
end

@given("a user with name {String}") do context, name
    context[:user] = User(name)
end

@when("the user scores {Int} point") do context, point
    scoresdb = context[:scoresdb]
    user = context[:user]

    recordscore!(scoresdb, user, Score("defaultkey", point))
end

@when("the user scores {Int} point with score key {String}") do context, point, key
    scoresdb = context[:scoresdb]
    user = context[:user]

    recordscore!(scoresdb, user, Score(key, point))
end

@then("the user has score {Int} on the scoreboard") do context, score
    scoresdb = context[:scoresdb]
    user = context[:user]

    @expect userscore(scoresdb, user) == score
end
