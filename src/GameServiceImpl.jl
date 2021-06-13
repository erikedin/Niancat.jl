module GameServiceImpl

using Niancat.Gameface
using Niancat.Persistence
using Niancat.Http
using Niancat.Users
using Niancat.Scores
using Niancat.Formatters
using Niancat.Languages
import Niancat.Gameface: score!, gameinstanceid, notify!, event!, finddictionary

"""
ConcreteGameService is merely the implementation of the `GameService` interface.
The interface is abstract for testing purposes.
"""
struct ConcreteGameService <: GameService
    instanceinfo::InstanceInfo
    gameinstanceid::Int
    persistence::GameEventPersistence
    httpclient::HttpClient
end

Gameface.score!(g::ConcreteGameService, user::User, score::Score) = score!(g.persistence, user, score)
Gameface.gameinstanceid(g::ConcreteGameService) = g.gameinstanceid

function notifytext!(g::ConcreteGameService, text::String)
    endpoints = getnotificationendpoints(g.persistence, g.instanceinfo.databaseid)

    for endpoint in endpoints
        post(g.httpclient, endpoint, text)
    end
end

function Gameface.notify!(g::ConcreteGameService, notif::GameNotification)
    formatter = SlackFormatter()
    text = format(formatter, notif)

    notifytext!(g, text)
end

# SolutionboardNotifications only carry instructions that allow ConcreteGameService to
# find all the actual information that should be included in the notification.
# So instead of showing the notification itself, we fetch a solution board and show that.
function Gameface.notify!(g::ConcreteGameService, notif::SolutionboardNotification)
    board = getsolutionboard(g.persistence, notif.instanceid, notif.round)

    # TODO A real implementation should get the formatter for each team
    #      and format the notification accordingly.
    #      This skeleton implementation just uses a SlackFormatter.

    formatter = SlackFormatter()
    text = format(formatter, board)

    notifytext!(g, text)
end

function Gameface.notify!(g::ConcreteGameService, notif::ScoreboardNotification)
    board = getscoreboard(g.persistence, notif.instanceid, notif.round)

    # TODO A real implementation should get the formatter for each team
    #      and format the notification accordingly.
    #      This skeleton implementation just uses a SlackFormatter.

    formatter = SlackFormatter()
    text = format(formatter, board)

    notifytext!(g, text)
end

function Gameface.finddictionary(g::ConcreteGameService, dictionaryid::AbstractString) :: LanguageDictionary
    SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "PUSSGURKA",
        "ORDPUSSEL"
    ])
end

function Gameface.event!(g::ConcreteGameService, event::GameUserEvent)
    recordevent!(g.persistence, g.gameinstanceid, event)
end
function Gameface.event!(g::ConcreteGameService, event::GameEvent)
    recordevent!(g.persistence, g.gameinstanceid, event)
end

export ConcreteGameService

end