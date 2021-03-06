using Niancat.Formatters
import Niancat.Formatters: format

format(::SlackFormatter, r::Correct) = "Ordet $(r.word.w) är korrekt!"
format(::SlackFormatter, r::PuzzleIs) = r.puzzle
format(::SlackFormatter, r::NoPuzzleSet) = "Det finns inget pussel än."
format(::SlackFormatter, r::Incorrect) = "Ordet $(r.word.w) finns inte med i SAOL."
format(::SlackFormatter, r::Rejected) = "Inte ett giltigt pussel."
format(::SlackFormatter, r::NewPuzzle) = "Nya pusslet är $(r.puzzle)."

format(::SlackFormatter, r::CorrectNotification) = "$(r.user) löste nian!"