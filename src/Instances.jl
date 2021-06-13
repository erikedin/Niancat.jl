module Instances

using Niancat.Persistence
using Niancat.Gameface
using Niancat.Http
using Niancat.GameServiceImpl

mutable struct GameInstances
    factory::Ref{Function}
    initialstate::String
    game::Union{Game, Nothing}
    httpclient::HttpClient
    persistence::GamePersistence

    function GameInstances(httpclient::HttpClient, persistence::GamePersistence)
        new(Ref{Function}(), "", nothing, httpclient, persistence)
    end
end

function registergame!(gi::GameInstances, _name::String, initialstate::String, factory::Function)
    gi.factory[] = factory
    gi.initialstate = initialstate
end

function makegameservice(
    gi::GameInstances,
    description::GameInstanceDescription) :: GameService

    ConcreteGameService(description.instanceinfo, description.gameinstanceid, gi.persistence, gi.httpclient)
end

function loadgameinstances!(gi::GameInstances)
    instancedescriptions = getgameinstances(gi.persistence)

    if !isempty(instancedescriptions)
        description = first(instancedescriptions)
        f = gi.factory[]
        gi.game = f(description.state, makegameservice(gi, description))
    end
end

getgame(gi::GameInstances, _gamename::String, _instancename::String) = gi.game

function newgame!(gi::GameInstances, instancename::String, gamename::String)
    # TODO I could imagine having two versions of Niancat, one Swedish and one English.
    # They would be registered under different names, but have the same game name in the
    # database, just different initial states.
    # Then we shouldn't use gamename here, but the underlying database game name.
    description = newgameinstance!(gi.persistence, instancename, gamename, gi.initialstate)
    f = gi.factory[]
    gi.game = f(description.state, makegameservice(gi, description))
end

export GameInstances,  getgame, registergame!, newgame!

end