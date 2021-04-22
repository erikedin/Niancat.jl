using Behavior
using Niancat
using Test

include("games/niancat/runtests.jl")

@test runspec(pkgdir(Niancat), tags = "@scores")