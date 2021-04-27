module Scores

using Niancat
using Niancat.Users
using Niancat.Persistence
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
    VALUES
        (?,
         ?,
         ?,
         ?,
         ?);
    """
    DBInterface.execute(scoresdb.db, sql, (score.gamename, user.databaseid, score.round, score.key, score.value))
end

function getscoreboard(svcdb::ServiceDatabase, gamename::String)
    sql = """
    """
end

function userscore(scoresdb::ServiceDatabase, user::User) :: Int
    results = DBInterface.execute(scoresdb.db, "SELECT COUNT(*) FROM scores;")
    row = first(results)
    row[1]
end

export recordscore!, userscore, Score, initialize!
end