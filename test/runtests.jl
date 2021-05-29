using Behavior
using Niancat
using Test

#
# TestingGameService is a mock interface between
# a game and the Niancat service.
#
using Niancat.Gameface
using Niancat.Users
import Niancat.Gameface: score!, notify!

struct TestingGameService <: GameService
    scores::Vector{Tuple{User, Score}}
    notifications::Vector{GameNotification}

    TestingGameService() = new([], [])
end

Gameface.score!(tgs::TestingGameService, user::User, score::Score) = push!(tgs.scores, (user, score))
Gameface.notify!(tgs::TestingGameService, notification::GameNotification) = push!(tgs.notifications, notification)

lastnotification(tgs::TestingGameService) = tgs.notifications[end]

#
# Include test files
#

include("games/niancat/runtests.jl")

@test runspec(pkgdir(Niancat), tags = "not @wip", presenter = TerseRealTimePresenter(ColorConsolePresenter()))