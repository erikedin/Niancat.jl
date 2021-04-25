CREATE TABLE teams
(
    team_id     INTEGER PRIMARY KEY,
    team_name   TEXT NOT NULL UNIQUE,
    icon        TEXT NOT NULL UNIQUE,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO teams (team_name, icon) VALUES("default", "");

CREATE TABLE games
(
    game_id     INTEGER PRIMARY KEY,
    game_name   TEXT NOT NULL UNIQUE
);

CREATE TABLE users
(
    user_id         INTEGER PRIMARY KEY,
    team_user_id    TEXT NOT NULL,
    team_id         INTEGER NOT NULL    REFERENCES teams(team_id),
    display_name    TEXT NOT NULL
);

CREATE TABLE scores
(
    score_id    INTEGER PRIMARY KEY,
    game_id     INTEGER NOT NULL    REFERENCES games(game_id),
    user_id     INTEGER NOT NULL    REFERENCES users(user_id),
    round       TEXT NOT NULL,
    score_key   TEXT NOT NULL,
    points      FLOAT NOT NULL,
    timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(game_id, user_id, round, score_key)
);