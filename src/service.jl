using Niancat.Gameface
using Niancat.Users
using Niancat.Persistence
using Niancat.Instances
using Niancat.Http
using Niancat.Games.NiancatGames
import Niancat.Instances: registergame!
import Niancat.Persistence: getuser, updatenotificationendpoint!

# This is a placeholder until a proper implementation is done
using Niancat.Games.NiancatGames

using SQLite

struct NiancatService
    persistence::GamePersistence
    instances::GameInstances

    function NiancatService(db::SQLite.DB; httpclient :: HttpClient = RealHttpClient())
        # Initialize the database if it is empty.
        tableresult = SQLite.tables(db)
        tables = tableresult[:name]
        if isempty(tables)
            Persistence.initializedatabase!(db)
        end
        new(GamePersistence(db), GameInstances(httpclient))
    end
end

function findcommand(svc::NiancatService, user::User, command::String) :: Tuple{Game, GameCommand}
    # Dummy implementation that only returns the Niancat game in the default instance.
    game = getgame(svc.instances, "Niancat", "defaultinstance")

    if command == "!nian"
        game, NiancatGames.GetPuzzle()
    elseif startswith(command, "!sättnian")
        word = split(command)[2]
        game, NiancatGames.SetPuzzle(word)
    else
        game, NiancatGames.Guess(command)
    end
end

loadgameinstances!(svc::NiancatService) = Instances.loadgameinstances!(svc.instances, svc.persistence)
Instances.registergame!(svc::NiancatService, name::String, factory::Function) = registergame!(svc.instances, name, factory)

declareinstance!(svc::NiancatService, instancename::String) = Persistence.declareinstance!(svc.persistence, instancename)
listinstancenames(svc::NiancatService) :: Vector{String} = Persistence.listinstancenames(svc.persistence)

Persistence.getuser(svc::NiancatService, userid::String, teamname::String) :: User = getuser(svc.persistence, userid, teamname)
updateteamendpoint!(svc::NiancatService, teamname::AbstractString, uri::AbstractString) = updatenotificationendpoint!(svc.persistence, teamname, uri)

export NiancatService, findcommand, loadgameinstances!, declareinstance!, listinstancenames
export getuser, updateteamendpoint!