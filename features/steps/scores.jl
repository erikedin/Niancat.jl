using Behavior
using Niancat.Scores
using Niancat.AbstractGame
using Niancat.Persistence
import Niancat.AbstractGame: gameinstanceid, gameround

column(t::Gherkin.DataTable) = [row[1] for row in t]

getinstanceid(context, gamename::String) = context[:gameinstances][gamename]

struct FakeGame <: Game
    gameinstanceid::Int
    round::String
end
AbstractGame.gameinstanceid(game::FakeGame) = game.gameinstanceid
AbstractGame.gameround(game::FakeGame) = game.round

@given("games") do context
    db = context[:db]

    gamenames = column(context.datatable)

    gameinstances = Dict(["Niancat" => 1])
    nextinstanceid = 2

    for gamename in gamenames
        addgame(db, gamename)
        gameinstances[gamename] = nextinstanceid
        nextinstanceid += 1
    end

    context[:gameinstances] = gameinstances
end

@when("the user scores {Int} point") do context, point
    scoresdb = context[:db]
    user = context[:user]

    instanceid = getinstanceid(context, "Niancat")
    recordscore!(scoresdb, user, Score(instanceid, "round1", "defaultkey", point))
end

@when("the user scores {Int} point with score key {String}") do context, point, key
    scoresdb = context[:db]
    user = context[:user]

    instanceid = getinstanceid(context, "Niancat")
    recordscore!(scoresdb, user, Score(instanceid, "round1", key, point))
end

@then("the user has score {Int} on the scoreboard") do context, score
    scoresdb = context[:db]
    user = context[:user]

    instanceid = getinstanceid(context, "Niancat")
    fakegame = FakeGame(instanceid, "round1")

    scoreboard = getscoreboard(scoresdb, fakegame)
    @expect userscore(scoreboard, user) == score
end

@when("{String} scores {Int} points in game {String}") do context, username, points, gamename
    db = context[:db]
    users = context[:users]
    user = users[username]

    instanceid = getinstanceid(context, gamename)
    score = Score(instanceid, "round1", "defaultkey", points)

    recordscore!(db, user, score)
end

@when("{String} scores {Int} points in round {Int}") do context, username, points, round
    db = context[:db]
    users = context[:users]
    user = users[username]

    instanceid = getinstanceid(context, gamename)
    score = Score(instanceid, "$round", "defaultkey", points)

    recordscore!(db, user, score)
end

@then("{String} has score {Int} on the scoreboard for {String}") do context, username, points, gamename
    db = context[:db]
    users = context[:users]
    user = users[username]

    instanceid = getinstanceid(context, gamename)
    fakegame = FakeGame(instanceid, "round1")
    println("Getting scoreboard for instance id $instanceid")
    scoreboard = getscoreboard(db, fakegame)
    @expect userscore(scoreboard, user) == points
end