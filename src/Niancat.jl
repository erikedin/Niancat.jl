module Niancat

include("Users.jl")
include("AbstractGame.jl")
include("Languages.jl")
include("Persistence.jl")
include("Scores.jl")

module Games
include("Games/NiancatGames.jl")
end

end # module
