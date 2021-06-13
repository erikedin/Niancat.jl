module Instances

using Niancat.Persistence
using Niancat.Gameface
using Niancat.Http
using Niancat.GameServiceImpl

mutable struct GameInstances
    factory::Ref{Function}
    game::Union{Game, Nothing}
    httpclient::HttpClient
    GameInstances(httpclient::HttpClient) = new(Ref{Function}(), nothing, httpclient)
end

registergame!(gi::GameInstances, _name::String, factory::Function) = gi.factory[] = factory

function makegameservice(
    gi::GameInstances,
    persistence::GamePersistence,
    description::GameInstanceDescription) :: GameService

    ConcreteGameService(description.instanceinfo, description.gameinstanceid, persistence, gi.httpclient)
end

function loadgameinstances!(gi::GameInstances, db::GamePersistence)
    instancedescriptions = getgameinstances(db)

    description = first(instancedescriptions)
    f = gi.factory[]
    gi.game = f(description.state, makegameservice(gi, db, description))
end

getgame(gi::GameInstances, _gamename::String, _instancename::String) = gi.game

# function newgame!(gi::GameInstances, instancename::String, gamename::String, dictionaryid::String)
#     description = newgameinstance!(db, )
#     f = gi.factory[]
#     gi.game = f(description.state, makegameservice(gi, db, description))
# end

export GameInstances,  getgame, registergame!, newgame!

end