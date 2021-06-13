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

    registergame!(service, "Niancat", "#sv-14#", (state, gameservice) -> NiancatGame(state, gameservice))
    loadgameinstances!(service)

    newgame!(service, "defaultinstance", "Niancat")

    # Set a fake notification endpoint for the default team
    endpoint_url = "https://niancat.test/notification"
    updateteamendpoint!(service, "defaultteam", endpoint_url)

    context[:service] = service
    context[:httpclient] = httpclient
    context[:db] = service.persistence

    niancat = getgame(service.instances, "Niancat", "defaultinstance")
    context[:game] = niancat
    context[:dictionary] = niancat.dictionary
end

