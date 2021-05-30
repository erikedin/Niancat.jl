module Scores

using Niancat.Users
using Niancat.Persistence
using Niancat.Gameface
import Niancat.Gameface: score!
using SQLite

const UserScore = Tuple{User, Float32}

struct Scoreboard
    scores::Vector{UserScore}
end

function Gameface.score!(persistence::GamePersistence, user::User, score::Score)
    sql = """
        INSERT OR IGNORE INTO scores
            (game_instance_id, user_id, round, score_key, points)
        VALUES
            (?, ?, ?, ?, ?);
    """

    DBInterface.execute(persistence.db, sql, (score.gameinstanceid, user.databaseid, score.round, score.key, score.value))
end

function builduser(row)
    teamdatabaseid = row[:team_id]
    teamname = row[:team_name]
    teamicon = row[:icon]
    team = Team(teamdatabaseid, teamname, teamicon)

    userdatabaseid = row[:user_id]
    teamuserid = row[:team_user_id]

    User(userdatabaseid, teamuserid, team)
end

function getscoreboard(persistence::GamePersistence, game::Game) :: Scoreboard

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

hasuser(scoreboard::Scoreboard, user::User) :: Bool = any(((u, _s), ) -> u == user, scoreboard.scores)

struct Solutionboard
    solutions::Dict{String, Vector{User}}

    Solutionboard() = new(Dict{String, Vector{String}}())
end

function getsolutionboard(persistence::GamePersistence, game::Game, round::String) :: Solutionboard
    board = Solutionboard()

    # Fetch all possible solutions
    wordssql = """
        SELECT event_data
        FROM gameevents
        WHERE game_instance_id = ? AND round = ? AND event_type = ?;
    """
    wordsparams = (gameinstanceid(game), round, Gameface.GameEvent_Solution)
    wordsresults = DBInterface.execute(persistence.db, wordssql, wordsparams)
    allsolutions = [row[:event_data] for row in wordsresults]

    # Fetch all user solutions
    sql = """
        SELECT userevents.user_id, userevents.event_data, users.team_user_id, teams.team_id, teams.team_name, teams.icon
        FROM userevents
        JOIN users ON users.user_id = userevents.user_id
        JOIN teams ON users.team_id = teams.team_id
        WHERE userevents.game_instance_id = ? AND userevents.round = ? AND userevents.event_type = ?;
    """
    params = (gameinstanceid(game), round, Gameface.UserEvent_Solution)
    usersolutionresults = DBInterface.execute(persistence.db, sql, params)
    usersolutions = [(builduser(row), row[:event_data]) for row in usersolutionresults]

    # TODO Nicer implementation
    for word in allsolutions
        board.solutions[word] = User[]
    end

    for (user, word) in usersolutions
        push!(board.solutions[word], user)
    end

    board
end

export Scoreboard, getscoreboard, record!, Score, UserScore, userscore, hasuser, getsolutionboard

end