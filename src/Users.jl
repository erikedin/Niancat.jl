module Users

struct Team
    databaseid::Int
    name::String
    icon::String
end

struct User
    databaseid::Int
    userid::String
    team::Team
end

export User, Team

end