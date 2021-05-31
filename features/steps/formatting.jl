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

    context[:formattedresponse] = format(formatter, response)
end

@then("the formatted response is") do context
    text = context[:block_text]

    response = context[:formattedresponse]

    @expect text == response
end