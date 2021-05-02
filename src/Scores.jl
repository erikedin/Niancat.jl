module Scores

using Niancat
using Niancat.AbstractGame
using Niancat.Users
using Niancat.Persistence
using SQLite
using Tables

struct Score
    gameinstanceid::Int
    round::String
    key::String
    value::Int
end

struct Scoreboard
    scores::Dict{User, Float32}
end

function recordscore!(scoresdb::ServiceDatabase, user::User, score::Score)
    sql = """
    INSERT OR IGNORE INTO scores
        (game_instance_id, user_id, round, score_key, points)
    VALUES (?, ?, ?, ?, ?);
    """

    DBInterface.execute(scoresdb.db, sql, (score.gameinstanceid, user.databaseid, score.round, score.key, score.value))
end

function getscoreboard(svcdb::ServiceDatabase, game::Game) :: Scoreboard
    sql = """
    SELECT scores.user_id, SUM(scores.points) AS score
    FROM scores
    WHERE scores.game_instance_id = ?
      AND scores.round = ?
    GROUP BY scores.user_id;
    """
    results = DBInterface.execute(svcdb.db, sql, (gameinstanceid(game), gameround(game)))

    scoresbyid = Dict{Int, Float32}(
        [row[:user_id] => row[:score]
         for row in results])
    users = getexistingusers(svcdb, collect(keys(scoresbyid)))

    scores = Dict{User, Float32}(
        user => scoresbyid[user.databaseid]
        for user in users
    )

    Scoreboard(scores)
end

function userscore(scoreboard::Scoreboard, user::User) :: Int
    scoreboard.scores[user]
end

export recordscore!, userscore, Score, initialize!, getscoreboard
end