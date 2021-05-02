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
    results = DBInterface.execute(svcdb.db, sql, (gameinstanceid(game), gameround(game)))

    scores = Dict{User, Float32}(
        builduser(row) => row[:score]
        for row in results
    )

    Scoreboard(scores)
end

function userscore(scoreboard::Scoreboard, user::User) :: Int
    scoreboard.scores[user]
end

export recordscore!, userscore, Score, initialize!, getscoreboard
end