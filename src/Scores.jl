module Scores

using Niancat.Users
using Niancat.Persistence
using Niancat.Gameface
using SQLite

struct Score
    gameinstanceid::Int
    round::String
    key::String
    value::Float32
end

const UserScore = Tuple{User, Float32}

struct Scoreboard
    scores::Vector{UserScore}
end

function recordscore!(persistence::GamePersistence, user::User, score::Score)
    sql = """
        INSERT OR IGNORE INTO scores
            (game_instance_id, user_id, round, score_key, points)
        VALUES
            (?, ?, ?, ?, ?);
    """

    DBInterface.execute(persistence.db, sql, (score.gameinstanceid, user.databaseid, score.round, score.key, score.value))
end

function getscoreboard(persistence::GamePersistence, game::Game) :: Scoreboard
    builduser = row -> begin
        teamdatabaseid = row[:team_id]
        teamname = row[:team_name]
        teamicon = row[:icon]
        team = Team(teamdatabaseid, teamname, teamicon)

        userdatabaseid = row[:user_id]
        teamuserid = row[:team_user_id]

        User(userdatabaseid, teamuserid, team)
    end

    sql = """
        SELECT
            scores.user_id,
            SUM(scores.points) AS score,
            users.team_user_id,
            teams.team_id,
            teams.team_name,
            teams.icon
        FROM scores 
            JOIN teams ON users.team_id = teams.team_id
            JOIN users ON users.user_id = scores.user_id
        WHERE scores.game_instance_id = ?
          AND scores.round = ?
        GROUP BY scores.user_id;
    """
    results = DBInterface.execute(persistence.db, sql, (gameinstanceid(game), gameround(game)))

    scores = UserScore[(builduser(row), row[:score]) for row in results]

    Scoreboard(scores)
end

function userscore(scoreboard::Scoreboard, user::User) :: Float32
    d = Dict{User, Float32}(
        u => s
        for (u, s) in scoreboard.scores
    )
    d[user]
end

export Scoreboard, getscoreboard, recordscore!, Score, UserScore, userscore

end