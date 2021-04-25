# The Niancat Database

# Table: Teams
The table relates a numeric team id to a team name and a team icon.

Table name: `teams`

Columns:
- `id`
- `name`
- `icon`
- `created_at`

# Table: Games
Relates a numeric identifier to a type of game (e.g. Niancat or Nona).

Table name: `games`

Columns:
- `id`
- `name`

# Table: Users
Relates a numeric id of a user to a user name and a team.

Table name: `users`

Columns:
- `id`
- `team_user_id`
- `team_id`
- `display_name`

# Table: Scores
Stores a score event for each score made in any game.

The id is a numeric id for that particular event.
`game_id` identifies which game, obviously.
`user_id` identifies the user.
`round` is a string identifier for which round of the game this relates to.
A user may score several points during a round, and those points are aggregated.
`key` is a unique string identifier of the score event. Each round may have multiple
events with different keys, and those points are aggregated, but each key is unique.
`points` is a floating point number of how many points this score event has.

Motivation: In Niancat, a puzzle may have more than one solution. Each solution will
be a key, guaranteeing that a user may not score more than once for a given solution.

Table name: `scores`

Columns:
- `id`
- `game_id`
- `user_id`
- `round`
- `key` UNIQUE
- `points`
- `timestamp`

# Table: Game event types
Relates a numeric id to a string description of a type of game defined user event.

Table name: `game_event_types`

Columns:
- `id`
- `name`

# Table: Game events
Is a list of game defined events with timestamps.

Table name: `game_events`

Columns:
- `id`
- `type_id`
- `timestamp`
- `value`

