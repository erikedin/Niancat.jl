module Niancat

include("Languages.jl")
include("Users.jl")
include("Http.jl")
include("Gameface.jl")
include("Formatters.jl")
include("Persistence.jl")
include("Scores.jl")
include("GameServiceImpl.jl")
include("Instances.jl")

module Games
include("Games/NiancatGames.jl")
end

include("service.jl")

end # module
