using Behavior
using Niancat
using Niancat.Http
import Niancat.Http: post
using Niancat.Games.NiancatGames
using Niancat.Gameface: GameNotification
using SQLite

column(t::Behavior.Gherkin.DataTable) = [row[1] for row in t]

@given("that we add no instances") do context
    # Nothing to do.
end

@given("that we add instances") do context
    service = context[:service]
    instancenames = column(context.datatable)

    for name in instancenames
        declareinstance!(service, name)
    end
end

@when("all instances are listed") do context
    service = context[:service]
    instancenames = listinstancenames(service)

    context[:instancenames] = instancenames
end

@then("the listed instances are") do context
    expectedinstancenames = sort(column(context.datatable))
    actualinstancenames = sort(context[:instancenames])

    @expect expectedinstancenames == actualinstancenames
end

@given("a new database file") do context
    context[:databasefile] = Base.Filesystem.tempname()
end

@when("a Niancat service is started") do context
    databasefile = context[:databasefile]
    sqlitedb = SQLite.DB(databasefile)
    service = NiancatService(sqlitedb)

    registergame!(service, "Niancat", "#sv-14#", (state, gameservice) -> NiancatGame(state, gameservice))
    loadgameinstances!(service)

    context[:service] = service
end

@then("the database has the default tables") do context
    databasefile = context[:databasefile]
    sqlitedb = SQLite.DB(databasefile)

    result = SQLite.tables(sqlitedb)
    actualtables = result[:name]

    expectedtables = column(context.datatable)

    for expectedtable in expectedtables
        @expect expectedtable in actualtables
    end
end

@when("an existing database file") do context
    databasefile = Base.Filesystem.tempname()
    context[:databasefile] = databasefile

    sqlitedb = SQLite.DB(databasefile)
    service = NiancatService(sqlitedb)

    registergame!(service, "Niancat", "#sv-14#", (state, gameservice) -> NiancatGame(state, gameservice))
    loadgameinstances!(service)
    
    newgame!(service, "defaultinstance", "Niancat")

    context[:service] = service
end

@given("that the team defaultteam updates the notification endpoint to {String}") do context, endpoint_url
    service = context[:service]
    teamname = "defaultteam"

    updateteamendpoint!(service, teamname, endpoint_url)
end

struct SomeFakeNotification <: GameNotification
    msg::String
end

@when("a notification is sent for the instance defaultinstance") do context
    service = context[:service]
    somegame = getgame(service.instances, "Niancat", "defaultinstance")

    notify!(somegame.gameservice, SomeFakeNotification("You are notified"))
end

@then("the notification is sent to {String}") do context, endpoint_url
    httpclient = context[:httpclient]

    notifications_uris = [u for (u, _body) in httpclient.posts]

    @expect endpoint_url in notifications_uris
end