module Persistence

using SQLite
using Niancat

struct GameInstanceDescription
    gamename::String
    instancename::String
    state::String
end

function GameInstanceDescription(row)
    GameInstanceDescription(row[:game_name], row[:instance_name], row[:game_state])
end

function initializedatabase!(db::SQLite.DB)
    sqlscript = read(joinpath(pkgdir(Niancat), "extra", "niancat.sql"), String)
    stms = split(sqlscript, "\n\n")
    for stm in stms
        DBInterface.execute(db, stm)
    end
end

struct GamePersistence
    db::SQLite.DB

    function GamePersistence()
        db = SQLite.DB()
        initializedatabase!(db)
        new(db)
    end
end

function getgameinstances(persistence::GamePersistence) :: Vector{GameInstanceDescription}
    sql = """
        SELECT instances.instance_name, games.game_name, gameinstances.game_state
        FROM gameinstances
            JOIN games ON gameinstances.game_id = games.game_id
            JOIN instances ON gameinstances.instance_id = instances.instance_id;
    """
    results = DBInterface.execute(persistence.db, sql)

    [GameInstanceDescription(row) for row in results]
end

function getuser(persistence::GamePersistence, teamname::String, userid::String) :: User
    sql = """
    INSERT OR IGNORE INTO users
        (team_user_id, team_id, display_name)
    VALUES
        (?,
         (SELECT team_id FROM teams WHERE team_name = ?),
         ?);
    """

    DBInterface.execute(persistence.db, sql, (userid, teamname, userid))

    getsql = """
    SELECT users.user_id, users.team_id, teams.icon
    FROM users JOIN teams ON users.team_id = teams.team_id
    WHERE
        users.team_user_id = ? AND
        teams.team_name = ?;
    """

    results = DBInterface.execute(persistence.db, getsql, (userid, teamname))
    row = first(results)

    userdatabaseid = row[1]
    teamdatabaseid = row[2]
    teamicon = row[3]
    team = Team(teamdatabaseid, teamname, teamicon)

    User(userdatabaseid, userid, team)
end

export GamePersistence, GameInstanceDescription, getgameinstances, getuser

end