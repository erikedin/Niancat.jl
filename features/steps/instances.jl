using Behavior
using Niancat
using Niancat.Games.NiancatGames
using SQLite

column(t::Behavior.Gherkin.DataTable) = [row[1] for row in t]

@given("a default Niancat service") do context
    sqlitedb = SQLite.DB()
    initializedatabase!(sqlitedb)

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