using Niancat.Formatters
import Niancat.Formatters: format

format(::SlackFormatter, c::Correct) = "Ordet $(c.word.w) är korrekt!"