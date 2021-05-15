module Instances

using Niancat.Persistence
using Niancat.Gameface

mutable struct GameInstances
    factory::Ref{Function}
    game::Union{Game, Nothing}
    GameInstances() = new(Ref{Function}(), nothing)
end

registergame!(gi::GameInstances, _name::String, factory::Function) = gi.factory[] = factory

function loadgameinstances!(gi::GameInstances, db::GamePersistence)
    instancedescriptions = getgameinstances(db)

    description = first(instancedescriptions)
    f = gi.factory[]
    gi.game = f(description.state)
end

getgame(gi::GameInstances, _gamename::String, _instancename::String) = gi.game

export GameInstances,  getgame, registergame!

end