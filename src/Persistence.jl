module Persistence

using SQLite
using Niancat

function initializedatabase!(db::SQLite.DB)
    sqlscript = read(joinpath(pkgdir(Niancat), "extra", "niancat.sql"), String)
    stms = split(sqlscript, "\n\n")
    for stm in stms
        DBInterface.execute(db, stm)
    end
end

struct GamePersistence
    db::SQLite.DB

    function GamePersistence()
        db = SQLite.DB()
        initializedatabase!(db)
        new(db)
    end
end

export GamePersistence

end