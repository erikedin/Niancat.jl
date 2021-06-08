using Behavior
using Niancat.Users
using Niancat

@when("showing the user") do context
    svc = context[:service]
    olduser = context[:user]
    user = getuser(svc, olduser.userid, olduser.team.name)

    context[:displayed_user] = "$user"
end

@when("the display name is updated to {String}") do context, displayname
    user = context[:user]
    svc = context[:service]

    updatedisplayname!(svc, user, displayname)
end

@then("the displayed name is {String}") do context, expected
    displayedname = context[:displayed_user]

    @expect displayedname == expected
end