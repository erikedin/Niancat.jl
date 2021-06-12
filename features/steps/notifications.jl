using Behavior
using Niancat
using Niancat.Gameface
using Niancat.Scores

column(t::Behavior.Gherkin.DataTable) = [row[1] for row in t]

@when("a solution board notification is sent for the current round") do context
    game = context[:game]
    round = gameround(game)
    instanceid = gameinstanceid(game)

    # Note that this step assumes that the Game instance has a field
    # `gameservice`, which isn't necessarily the case always.
    # Should we create a getter for gameservice?
    gameservice = game.gameservice

    notify!(gameservice, SolutionboardNotification(instanceid, round))
end

@then("a notification is sent, containing words") do context
    # This is a fake HTTP client, where we can have a look at what
    # is actually sent to the network.
    httpclient = context[:httpclient]

    # These are the words we expect in some notification
    words = column(context.datatable)

    # Collect all text bodies sent
    bodies = [body for (_uri, body) in httpclient.posts]

    # Check that the expected words are all in _one of the bodies_.
    found_words = false

    for body in bodies
        found_words = all(w -> contains(body, w), words) || found_words
    end

    if !found_words
        println("Expected words: $(words)")
        println("Actual notifications: $(bodies)")
        @fail "Could not find the expected words in any notification"
    end
end