using Behavior
using Niancat
using Test

#
# TestingGameService is a mock interface between
# a game and the Niancat service.
#
using Niancat.Gameface
using Niancat.Users
using Niancat.Scores
import Niancat.Gameface: score!, notify!, event!

struct TestingGameService <: GameService
    scores::Vector{Tuple{User, Score}}
    notifications::Vector{GameNotification}
    userevents::Vector{GameUserEvent}
    gameevents::Vector{GameEvent}
    instanceid::Int

    TestingGameService(instanceid::Int = 1) = new([], [], [], [], instanceid)
end

Gameface.score!(tgs::TestingGameService, user::User, score::Score) = push!(tgs.scores, (user, score))
Gameface.notify!(tgs::TestingGameService, notification::GameNotification) = push!(tgs.notifications, notification)
Gameface.event!(tgs::TestingGameService, event::GameUserEvent) = push!(tgs.userevents, event)
Gameface.event!(tgs::TestingGameService, event::GameEvent) = push!(tgs.gameevents, event)
Gameface.gameinstanceid(tgs::TestingGameService) = tgs.instanceid

lastnotification(tgs::TestingGameService) = tgs.notifications[end]
lastuserevent(tgs::TestingGameService) = tgs.userevents[end]
lastgameevent(tgs::TestingGameService) = tgs.gameevents[end]

#
# Include test files
#

include("games/niancat/runtests.jl")

@test runspec(pkgdir(Niancat), tags = "not @wip", presenter = TerseRealTimePresenter(ColorConsolePresenter()))