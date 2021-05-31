module Formatters

using Niancat.Gameface

abstract type Formatter end

format(::Formatter, ::Response) = error("Implement format for Response in Formatter subtypes")
format(::Formatter, ::GameNotification) = error("Implement format for GameNotification in Formatter subtypes")

struct SlackFormatter <: Formatter end

# The default implementations just stringify the types, which isn't great
# but perhaps better than failing with a MethodError or error.
format(::SlackFormatter, response::Response) = string(response)
format(::SlackFormatter, notification::GameNotification) = string(notification)

export Formatter, SlackFormatter
export format

end