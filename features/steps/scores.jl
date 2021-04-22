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

@when("the user solves a puzzle") do context
    scoresdb = context[:scoresdb]
    user = context[:user]

    recordscore!(scoresdb, user, Score("foo"))
end

@when("the user solves the puzzle again with a different solution") do context
    scoresdb = context[:scoresdb]
    user = context[:user]

    recordscore!(scoresdb, user, Score("bar"))
end

@then("the user has score {Int} on the scoreboard") do context, score
    scoresdb = context[:scoresdb]
    user = context[:user]

    @expect userscore(scoresdb, user) == score
end

@when("the user solves the puzzle again with the same solution") do context
    scoresdb = context[:scoresdb]
    user = context[:user]

    recordscore!(scoresdb, user, Score("foo"))
end
