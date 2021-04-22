module Scores

using Niancat.Users
using SQLite
using Tables

struct Score
    key::String
    value::Int

    Score(key::String) = new(key, 1)
end

struct ScoresDatabase
    db::SQLite.DB

    ScoresDatabase() = new(SQLite.DB())
end

function initialize!(scoresdb::ScoresDatabase)
    SQLite.createtable!(scoresdb.db, "scores", Tables.Schema(("username", "key", "score"), (String, String, Int)))
    SQLite.createindex!(scoresdb.db, "scores", "scoreskey", "key")
end

function recordscore!(scoresdb::ScoresDatabase, user::User, score::Score)
    DBInterface.execute(scoresdb.db, "INSERT OR IGNORE INTO scores VALUES(?, ?, ?);", (user.userid, score.key, score.value))
end

function userscore(scoresdb::ScoresDatabase, user::User) :: Int
    results = DBInterface.execute(scoresdb.db, "SELECT COUNT(*) FROM scores;")
    row = first(results)
    row[1]
end

export ScoresDatabase, recordscore!, userscore, Score, initialize!
end