using Behavior
using Niancat.Persistence
using Niancat.Users

function getordefault(context, key::Symbol, default)
    if haskey(context, key)
        context[key]
    else
        context[key] = default
        default
    end
end

@given("a Niancat database") do context
    db = ServiceDatabase()
    context[:db] = db
end

@given("a team {String}") do context, teamname
    db = context[:db]

    addteam(db, teamname, string(first(teamname)))
end

@given("a user {String}") do context, name
    db = context[:db]

    user = getuser(db, Persistence.DEFAULT_TEAM, name)

    users = getordefault(context, :users, Dict{String, User}())
    users[name] = user
end

@given("a user/team {String} in team {String}") do context, name, teamname
    db = context[:db]

    user = getuser(db, teamname, name)

    users = getordefault(context, :users, Dict{String, User}())
    users[name] = user
end

@when("fetching a user {String}") do context, name
    db = context[:db]

    user = getuser(db, Persistence.DEFAULT_TEAM, name)

    context[:fetcheduser] = user
end

@when("fetching a user/team {String} in team {String}") do context, name, teamname
    db = context[:db]

    user = getuser(db, teamname, name)

    context[:fetcheduser] = user
end

@then("the user id for {String} matches the id when created") do context, name
    fetched_user = context[:fetcheduser]
    user = context[:users][name]

    @expect user.databaseid == fetched_user.databaseid
end

@then("{String} and {String} have different user ids") do context, username1, username2
    users = context[:users]
    user1 = users[username1]
    user2 = users[username2]

    @expect user1.databaseid != user2.databaseid
end