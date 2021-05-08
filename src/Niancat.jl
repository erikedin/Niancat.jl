module Niancat

include("Languages.jl")
include("Users.jl")
include("Gameface.jl")
include("Persistence.jl")
include("Instances.jl")
include("Scores.jl")

module Games
include("Games/NiancatGames.jl")
end

end # module
