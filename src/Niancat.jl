module Niancat

include("Languages.jl")
include("Users.jl")

module Games
include("Games/Games.jl")
include("Games/NiancatGames.jl")
end

end # module
