module Scores

using Niancat
using Niancat.Users
using SQLite
using Tables

struct Score
    key::String
    value::Int
end

struct ScoresDatabase
    db::SQLite.DB

    ScoresDatabase() = new(SQLite.DB())
end

function initialize!(scoresdb::ScoresDatabase)
    sqlscript = read(joinpath(pkgdir(Niancat), "extra", "niancat.sql"), String)
    stms = split(sqlscript, "\n\n")
    for stm in stms
        DBInterface.execute(scoresdb.db, stm)
    end

    println("Tables: ", SQLite.tables(scoresdb.db))
end

function recordscore!(scoresdb::ScoresDatabase, user::User, score::Score)
    sql = """INSERT OR IGNORE INTO
        scores (game_id, user_id, round, score_key, points)
        VALUES(?, ?, ?, ?, ?);
    """
    DBInterface.execute(scoresdb.db, sql, (score.gameid, user.userid, score.round, score.key, score.value))
end

function userscore(scoresdb::ScoresDatabase, user::User) :: Int
    results = DBInterface.execute(scoresdb.db, "SELECT COUNT(*) FROM scores;")
    row = first(results)
    row[1]
end

export ScoresDatabase, recordscore!, userscore, Score, initialize!
end