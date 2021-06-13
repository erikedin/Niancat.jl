module Persistence

using SQLite
using Niancat
using Niancat.Users
using Niancat.Gameface

struct GameInstanceDescription
    instanceinfo::InstanceInfo
    gamename::String
    gameinstanceid::Int
    state::String
end

function GameInstanceDescription(row)
    instanceinfo = InstanceInfo(row[:instance_id], row[:instance_name])
    GameInstanceDescription(instanceinfo, row[:game_name], row[:game_instance_id], row[:game_state])
end

function initializedatabase!(db::SQLite.DB)
    sqlscript = read(joinpath(pkgdir(Niancat), "extra", "niancat.sql"), String)
    stms = split(sqlscript, "\n\n")
    for stm in stms
        DBInterface.execute(db, stm)
    end
end

struct GamePersistence <: GameEventPersistence
    db::SQLite.DB

    function GamePersistence()
        db = SQLite.DB()
        initializedatabase!(db)
        new(db)
    end

    GamePersistence(db::SQLite.DB) = new(db)
end

function getgameinstances(persistence::GamePersistence) :: Vector{GameInstanceDescription}
    sql = """
        SELECT
            instances.instance_id, instances.instance_name,
            games.game_name,
            gameinstances.game_state,
            gameinstances.game_instance_id
        FROM gameinstances
            JOIN games ON gameinstances.game_id = games.game_id
            JOIN instances ON gameinstances.instance_id = instances.instance_id;
    """
    results = DBInterface.execute(persistence.db, sql)

    [GameInstanceDescription(row) for row in results]
end

function newgameinstance!(persistence::GamePersistence, instancename::String, gamename::String, initialstate::String)
    sql = """
        INSERT INTO gameinstances
            (game_id, instance_id, game_state)
        VALUES (
            (SELECT game_id FROM games WHERE game_name = ?),
            (SELECT instance_id FROM instances WHERE instance_name = ?),
            ?
        )
    """
    DBInterface.execute(persistence.db, sql, (gamename, instancename, initialstate))
    game_instance_id = SQLite.last_insert_rowid(persistence.db)

    readback_sql = """
        SELECT
            instances.instance_id, instances.instance_name,
            games.game_name,
            gameinstances.game_state,
            gameinstances.game_instance_id
        FROM gameinstances
            JOIN games ON gameinstances.game_id = games.game_id
            JOIN instances ON gameinstances.instance_id = instances.instance_id
        WHERE gameinstances.game_instance_id = ? 
    """
    results = DBInterface.execute(persistence.db, readback_sql, (game_instance_id, ))
    row = first(results)

    GameInstanceDescription(row)
end

function getuser(persistence::GamePersistence, userid::String, teamname::String) :: User
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
    SELECT users.user_id, users.team_id, users.display_name, teams.icon
    FROM users JOIN teams ON users.team_id = teams.team_id
    WHERE
        users.team_user_id = ? AND
        teams.team_name = ?;
    """

    results = DBInterface.execute(persistence.db, getsql, (userid, teamname))
    row = first(results)

    userdatabaseid = row[1]
    teamdatabaseid = row[2]
    displayname = row[3]
    teamicon = row[4]
    team = Team(teamdatabaseid, teamname, teamicon)

    User(userdatabaseid, userid, displayname, team)
end

function updatedisplayname!(persistence::GamePersistence, user::User, displayname::String)
    sql = """
        UPDATE users
        SET display_name = ?
        WHERE user_id = ?
    """
    DBInterface.execute(persistence.db, sql, (displayname, user.databaseid))
end

function listinstancenames(persistence::GamePersistence) :: Vector{String}
    sql = "SELECT instance_name FROM instances;"

    results = DBInterface.execute(persistence.db, sql)

    [row[:instance_name] for row in results]
end

function declareinstance!(persistence::GamePersistence, instancename::String)
    sql = """
        INSERT OR IGNORE INTO instances (instance_name)
        VALUES (?);
    """
    DBInterface.execute(persistence.db, sql, (instancename,))
end

function updatenotificationendpoint!(persistence::GamePersistence, teamname::AbstractString, uri::AbstractString)
    sql = """
        REPLACE INTO teamnotifications (team_id, uri)
        VALUES
            (
                (SELECT team_id FROM teams WHERE team_name = ?),
                ?
            );
    """
    DBInterface.execute(persistence.db, sql, (teamname, uri))
end

function getnotificationendpoints(persistence::GamePersistence, instancedatabaseid::Int) :: Vector{String}
    sql = """
            SELECT uri
            FROM teamnotifications
            JOIN teams ON teams.team_id = teamnotifications.team_id
            WHERE teams.instance_id = ?
            ;"""

    results = DBInterface.execute(persistence.db, sql, (instancedatabaseid,))

    [row[:uri] for row in results]
end

function recordevent!(persistence::GamePersistence, gameinstanceid::Int, event::GameUserEvent)
    sql = """
        INSERT INTO userevents
            (game_instance_id, user_id, round, event_type, event_data)
        VALUES
            (?,                ?,       ?,     ?,          ?);
    """
    params = (gameinstanceid, event.user.databaseid, event.round, event.eventtype, event.data)
    DBInterface.execute(persistence.db, sql, params)
end

function recordevent!(persistence::GamePersistence, gameinstanceid::Int, event::GameEvent)
    sql = """
        INSERT INTO gameevents
            (game_instance_id, round, event_type, event_data)
        VALUES
            (?,                ?,     ?,          ?);
    """
    params = (gameinstanceid, event.round, event.eventtype, event.data)
    DBInterface.execute(persistence.db, sql, params)
end

export GamePersistence, GameInstanceDescription, getgameinstances, getuser, initializedatabase!
export updatenotificationendpoint!, getnotificationendpoints, recordevent!
export updatedisplayname!, newgameinstance!

end