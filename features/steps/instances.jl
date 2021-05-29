using Behavior
using Niancat
using Niancat.Games.NiancatGames
using Niancat.Gameface: GameNotification
using SQLite

column(t::Behavior.Gherkin.DataTable) = [row[1] for row in t]

@given("a default Niancat service") do context
    sqlitedb = SQLite.DB()
    service = NiancatService(sqlitedb)

    # TODO This ought to be done by other means as soon
    #      as those means exist.
    # Load the default Niancat.
    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(service, "Niancat", (_state) -> NiancatGame(dictionary, service.persistence))
    loadgameinstances!(service)

    context[:service] = service
end

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

    # TODO This ought to be done by other means as soon
    #      as those means exist.
    # Load the default Niancat.
    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(service, "Niancat", (_state) -> NiancatGame(dictionary, service.persistence))
    loadgameinstances!(service)

    context[:service] = service
end

@then("the database has the default tables") do context
    databasefile = context[:databasefile]
    sqlitedb = SQLite.DB(databasefile)

    result = SQLite.tables(sqlitedb)
    actualtables = result[:name]

    expectedtables = column(context.datatable)

    @expect actualtables == expectedtables
end

@when("an existing database file") do context
    databasefile = Base.Filesystem.tempname()
    context[:databasefile] = databasefile

    sqlitedb = SQLite.DB(databasefile)
    service = NiancatService(sqlitedb)

    # TODO This ought to be done by other means as soon
    #      as those means exist.
    # Load the default Niancat.
    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(service, "Niancat", (_state) -> NiancatGame(dictionary, service.persistence))
    loadgameinstances!(service)

    context[:service] = service
end

@given("that the team defaultteam updates the notification endpoint to {String}") do context, endpoint_url
    service = context[:service]

    updatenotificationendpoint(service, teamname, endpoint_url)
end

struct SomeFakeNotification <: GameNotification
    msg::String
end

@when("a notification is sent for the instance defaultinstance") do context
    service = context[:service]
    instance = getinstance(service)

    notify(instance, SomeFakeNotification("You are notified"))
end

@then("the notification is sent to {String}") do context, endpoint_url
    @fail "Implement me"
end