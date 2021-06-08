module Users

struct Team
    databaseid::Int
    name::String
    icon::String
end

struct User
    databaseid::Int
    userid::String
    displayname::String
    team::Team
end

Base.print(io::IO, user::User) = print(io, user.displayname)

export User, Team

end