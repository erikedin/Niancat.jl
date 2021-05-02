CREATE TABLE instances
(
    instance_id     INTEGER PRIMARY KEY,
    instance_name   TEXT NOT NULL UNIQUE,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO instances (instance_id, instance_name) VALUES (1, "defaultinstance");

CREATE TABLE teams
(
    team_id     INTEGER PRIMARY KEY,
    team_name   TEXT NOT NULL UNIQUE,
    icon        TEXT NOT NULL UNIQUE,
    instance_id INTEGER NOT NULL    REFERENCES instances(instance_id),
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO teams (team_id, team_name, icon, instance_id) VALUES(1, "default", "", 1);

CREATE TABLE games
(
    game_id     INTEGER PRIMARY KEY,
    game_name   TEXT NOT NULL UNIQUE
);

INSERT INTO games (game_id, game_name) VALUES (1, "Niancat");

CREATE TABLE gameinstances
(
    game_instance_id    INTEGER PRIMARY KEY,
    game_id             INTEGER NOT NULL    REFERENCES games(game_id),
    instance_id         INTEGER NOT NULL    REFERENCES instances(instance_id),
    game_state          TEXT NOT NULL,
    UNIQUE(game_id, instance_id)
);

INSERT INTO gameinstances (game_instance_id, game_id, instance_id, game_state)
VALUES (1, 1, 1, "");

CREATE TABLE users
(
    user_id         INTEGER PRIMARY KEY,
    team_user_id    TEXT NOT NULL,
    team_id         INTEGER NOT NULL    REFERENCES teams(team_id),
    display_name    TEXT NOT NULL,
    UNIQUE(team_user_id, team_id),
    UNIQUE(team_id, display_name)
);

CREATE TABLE scores
(
    score_id            INTEGER PRIMARY KEY,
    game_instance_id    INTEGER NOT NULL    REFERENCES gamesinstances(game_instance_id),
    user_id             INTEGER NOT NULL    REFERENCES users(user_id),
    round               TEXT NOT NULL,
    score_key           TEXT NOT NULL,
    points              FLOAT NOT NULL,
    timestamp           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_instance_id, user_id, round, score_key)
);
