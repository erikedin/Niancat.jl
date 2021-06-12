using Behavior
using Niancat
using Niancat.Http
import Niancat.Http: post
using SQLite

##
## FakeHttpClient is used to remove actual network operations from the
## tests, and also for verifying that notifications are made properly.
##

struct FakeHttpClient <: HttpClient
    posts::Vector{Tuple{String, String}}

    FakeHttpClient() = new([])
end

Http.post(c::FakeHttpClient, uri::String, body::String) = push!(c.posts, (uri, body))

##
## This is a place for common steps that are used by many features in
## in the Background section.
##

@given("a default Niancat service") do context
    sqlitedb = SQLite.DB()
    httpclient = FakeHttpClient()
    service = NiancatService(sqlitedb, httpclient=httpclient)

    # TODO This ought to be done by other means as soon
    #      as those means exist.
    # Load the default Niancat.
    dictionary = SwedishDictionary([
        "DATORSPEL",
        "LEDARPOST",
        "ORDPUSSEL",
        "PUSSGURKA",
    ])
    registergame!(service, "Niancat", (_state, gameservice) -> NiancatGame(dictionary, gameservice))
    loadgameinstances!(service)

    context[:service] = service
    context[:httpclient] = httpclient
    context[:db] = service.persistence
    context[:dictionary] = dictionary

    niancat = getgame(service.instances, "Niancat", "defaultinstance")
    context[:game] = niancat
end

