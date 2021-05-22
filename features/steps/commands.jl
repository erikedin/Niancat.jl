using Behavior
using Niancat.Gameface
using Niancat.Users
using Niancat.Games.NiancatGames

@when("Erik sends the command \"{String}\"") do context, commandstring
    svc = context[:service]
    user = context[:user]

    game, command = findcommand(svc, user, commandstring)
    context[:foundgame] = game
    context[:foundcommand] = command
end

@then("the service finds the game Niancat in the default instance") do context
    foundgame = context[:foundgame]
    expectedgame = context[:game]

    @expect gameinstanceid(foundgame) == gameinstanceid(expectedgame)
end

@then("the command is GetPuzzle()") do context
    command = context[:foundcommand]

    @expect command == NiancatGames.GetPuzzle()
end

@then("the command is Guess(\"{String}\")") do context, word
    command = context[:foundcommand]

    @expect command == NiancatGames.Guess(word)
end

@then("the command is SetPuzzle(\"{String}\")") do context, word
    command = context[:foundcommand]

    @expect command == NiancatGames.SetPuzzle(word)
end