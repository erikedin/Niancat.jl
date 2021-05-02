module Scores

using Niancat
using Niancat.Users
using Niancat.Persistence
using Niancat.Games
using SQLite
using Tables

struct Score
    gamename::String
    round::String
    key::String
    value::Int
end

struct Scoreboard
    scores::Dict{User, Int}
end

function recordscore!(scoresdb::ServiceDatabase, user::User, score::Score)
    sql = """
    INSERT OR IGNORE INTO scores
        (game_id, user_id, round, score_key, points)
    VALUES (?, ?, ?, ?, ?);
    """
    DBInterface.execute(scoresdb.db, sql, (score.gamename, user.databaseid, score.round, score.key, score.value))
end

function getscoreboard(svcdb::ServiceDatabase, game::Game) :: Scoreboard
    sql = """
    SELECT SUM(scores.points)
    FROM scores
    WHERE scores.game_instance_id = ?
      AND scores.round = ?
    GROUP BY scores.user_id
    """
    DBInterface.execute(svcdb.db, sql, (gameinstanceid(game), gameround(game)))
end

function userscore(scoreboard::Scoreboard, user::User) :: Int
    scoreboard.scores[user]
end

export recordscore!, userscore, Score, initialize!, getscoreboard
end