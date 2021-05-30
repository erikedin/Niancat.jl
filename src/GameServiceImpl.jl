module GameServiceImpl

using Niancat.Gameface
using Niancat.Persistence
using Niancat.Http
using Niancat.Users
import Niancat.Gameface: score!, gameinstanceid, notify!, event!

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

function Gameface.notify!(g::ConcreteGameService, notif::GameNotification)
    endpoints = getnotificationendpoints(g.persistence, g.instanceinfo.databaseid)

    for endpoint in endpoints
        post(g.httpclient, endpoint, string(notif))
    end
end

function Gameface.event!(g::ConcreteGameService, event::GameUserEvent)
    recordevent!(g.persistence, g.gameinstanceid, event)
end
function Gameface.event!(g::ConcreteGameService, event::GameEvent)
    recordevent!(g.persistence, g.gameinstanceid, event)
end

export ConcreteGameService

end