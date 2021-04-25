module Persistence

using Niancat
using Niancat.Users
using SQLite

function initialize!(db::SQLite.DB)
    sqlscript = read(joinpath(pkgdir(Niancat), "extra", "niancat.sql"), String)
    stms = split(sqlscript, "\n\n")
    for stm in stms
        DBInterface.execute(db, stm)
    end
end

struct ServiceDatabase
    db::SQLite.DB

    function ServiceDatabase()
        db = SQLite.DB()
        initialize!(db)
        new(db)
    end
end

const DEFAULT_TEAM = 1

function getuser(svcdb::ServiceDatabase, teamid::Int, userid::String) :: User
    sql = "INSERT OR IGNORE INTO users (team_user_id, team_id, display_name) VALUES (?, ?, ?)"

    DBInterface.execute(svcdb.db, sql, (userid, teamid, userid))

    results = DBInterface.execute(svcdb.db, "SELECT user_id FROM users WHERE team_id = ? AND team_user_id = ?;", (teamid, userid))
    row = first(results)

    databaseid = row[1]

    User(databaseid, userid)
end

export ServiceDatabase, getuser

end