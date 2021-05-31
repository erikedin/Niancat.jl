module Formatters

using Niancat.Gameface

abstract type Formatter end

format(::Formatter, response::Response) = error("Implement format for Response in Formatter subtypes")

struct SlackFormatter <: Formatter end

format(::SlackFormatter, ::Response) = string(response)

export Formatter, SlackFormatter
export format

end