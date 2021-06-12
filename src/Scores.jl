module Scores

using Niancat.Users
using Niancat.Persistence
using Niancat.Gameface
using Niancat.Formatters
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
    displayname = row[:display_name]
    teamuserid = row[:team_user_id]

    User(userdatabaseid, teamuserid, displayname, team)
end

function getscoreboard(persistence::GamePersistence, instanceid::Int, round::String) :: Scoreboard

    sql = """
        SELECT
            scores.user_id,
            SUM(scores.points) AS score,
            users.team_user_id,
            users.display_name,
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
    results = DBInterface.execute(persistence.db, sql, (instanceid, round))

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

function getsolutionboard(persistence::GamePersistence, instanceid::Int, round::String) :: Solutionboard
    board = Solutionboard()

    # Fetch all possible solutions
    wordssql = """
        SELECT event_data
        FROM gameevents
        WHERE game_instance_id = ? AND round = ? AND event_type = ?;
    """
    wordsparams = (instanceid, round, Gameface.GameEvent_Solution)
    wordsresults = DBInterface.execute(persistence.db, wordssql, wordsparams)
    allsolutions = [row[:event_data] for row in wordsresults]

    # Fetch all user solutions
    sql = """
        SELECT userevents.user_id, userevents.event_data, users.team_user_id, users.display_name, teams.team_id, teams.team_name, teams.icon
        FROM userevents
        JOIN users ON users.user_id = userevents.user_id
        JOIN teams ON users.team_id = teams.team_id
        WHERE userevents.game_instance_id = ? AND userevents.round = ? AND userevents.event_type = ?;
    """
    params = (instanceid, round, Gameface.UserEvent_Solution)
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

##
## Notifications
##

struct SolutionboardNotification <: GameNotification
    instanceid::Int
    round::String
end

##
## Formatting
##
function formatsolution(word::String, users::Vector{User}) :: String
    usertext = join(["$(u)" for u in users], ",")
    # TODO This should technically be done in the language module.
    wordtext = uppercase(word)
    "$(wordtext): $(usertext)"
end

function Formatters.format(::SlackFormatter, board::Solutionboard)
    solutions = [
        formatsolution(word, users)
        for (word, users) in board.solutions
    ]
    join(solutions, "\n")
end

##
## Export
##

export Scoreboard, getscoreboard, record!, Score, UserScore, userscore, hasuser, getsolutionboard
export SolutionboardNotification

end