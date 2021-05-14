using Niancat.Gameface
using Niancat.Users

struct NiancatService
    persistence::GameEventPersistence
end

function findcommand(svc::NiancatService, user::User, command::String) :: Tuple{Game, GameCommand}
    error("Not implemented")
end

export NiancatService, findcommand