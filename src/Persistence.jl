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

const DEFAULT_TEAM = "default"

function getuser(svcdb::ServiceDatabase, teamname::String, userid::String) :: User
    sql = """
    INSERT OR IGNORE INTO users
        (team_user_id, team_id, display_name)
    VALUES
        (?,
         (SELECT team_id FROM teams WHERE team_name = ?),
         ?);
    """

    DBInterface.execute(svcdb.db, sql, (userid, teamname, userid))

    getsql = """
    SELECT users.user_id, users.team_id, teams.icon
    FROM users JOIN teams ON users.team_id = teams.team_id
    WHERE
        users.team_user_id = ? AND
        teams.team_name = ?;
    """

    results = DBInterface.execute(svcdb.db, getsql, (userid, teamname))
    row = first(results)

    userdatabaseid = row[1]
    teamdatabaseid = row[2]
    teamicon = row[3]
    team = Team(teamdatabaseid, teamname, teamicon)

    User(userdatabaseid, userid, team)
end

function addteam(svcdb::ServiceDatabase, teamname::String, icon::String)
    sql = """
    INSERT INTO teams (team_name, icon) VALUES (?, ?)
    """
    DBInterface.execute(svcdb.db, sql, (teamname, icon))
end

export ServiceDatabase, getuser, addteam

end