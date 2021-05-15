using Niancat.Gameface
using Niancat.Users
using Niancat.Persistence
using Niancat.Instances
import Niancat.Instances: registergame!

# This is a placeholder until a proper implementation is done
using Niancat.Games.NiancatGames

using SQLite

struct NiancatService
    persistence::GamePersistence
    instances::GameInstances

    NiancatService(db::SQLite.DB) = new(GamePersistence(db), GameInstances())
end

function findcommand(svc::NiancatService, user::User, command::String) :: Tuple{Game, GameCommand}
    # Dummy implementation that only returns the Niancat game in the default instance.
    game = getgame(svc.instances, "Niancat", "defaultinstance")

    if command == "!nian"
        game, NiancatGames.GetPuzzle()
    else
        game, NiancatGames.Guess(command)
    end
end

loadgameinstances!(svc::NiancatService) = Instances.loadgameinstances!(svc.instances, svc.persistence)
Instances.registergame!(svc::NiancatService, name::String, factory::Function) = registergame!(svc.instances, name, factory)

export NiancatService, findcommand, loadgameinstances!