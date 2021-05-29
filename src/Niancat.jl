module Niancat

include("Languages.jl")
include("Users.jl")
include("Http.jl")
include("Gameface.jl")
include("Persistence.jl")
include("GameServiceImpl.jl")
include("Instances.jl")
include("Scores.jl")

module Games
include("Games/NiancatGames.jl")
end

include("service.jl")

end # module
