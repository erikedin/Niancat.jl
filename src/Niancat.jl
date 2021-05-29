module Niancat

include("Languages.jl")
include("Users.jl")
include("Gameface.jl")
include("Http.jl")
include("Persistence.jl")
include("Instances.jl")
include("Scores.jl")

module Games
include("Games/NiancatGames.jl")
end

include("service.jl")

end # module
