using Behavior
using Niancat
using Niancat.Games.NiancatGames
using Niancat.Formatters

@given("that the team defaultteam uses Slack formatting in Swedish") do context
    service = context[:service]

    updateformatting!(service, "defaultteam", "Slack", "sv")
end

@when("we format a Correct(\"PUSSGURKA\") response") do context
    service = context[:service]

    formatter = getformatter(service, "defaultteam")
    response = NiancatGames.Correct("PUSSGURKA")

    context[:text] = format(formatter, response)
end

@when("the notification CorrectNotification for user Erik is formatted") do context
    service = context[:service]

    user = getuser(service, "Erik", "defaultteam")
    notification = NiancatGames.CorrectNotification(user)

    formatter = getformatter(service, "defaultteam")
    context[:text] = format(formatter, notification)
end

@then("the formatted response is") do context
    expected = context[:block_text]

    response = context[:text]

    @expect response == expected
end