module Niancat

include("Languages.jl")
include("Users.jl")
include("Gameface.jl")

module Games
include("Games/NiancatGames.jl")
end

end # module
