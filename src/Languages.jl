module Languages

using Unicode

struct Word
    w::String
end

isinalphabet(c::Char) :: Bool = occursin(c, "abcdefghijklmnopqrstuvwxyzåäö")
ismeaningfuldiacritic(c::Char) :: Bool = occursin(c, "åäö")

function normalizechar(c::AbstractChar) :: String
    stripmark = !ismeaningfuldiacritic(c)
    Unicode.normalize(string(c), stripmark=stripmark)
end

function normalize(s::String) :: String
    lower = Unicode.normalize(s, casefold=true)
    normalizedchars = [normalizechar(c) for c in lower]

    normalizedword = join(normalizedchars)
    filter(isinalphabet, normalizedword)
end

function sortword(s::String) :: String
    ns = normalize(s)
    String(sort([c for c in ns]))
end

isanagram(s1::String, s2::String) = sortword(s1) == sortword(s2)

struct SwedishDictionary
    words::Set{Word}

    function SwedishDictionary(words::AbstractVector{<:String})
        normalizedwords = [Word(normalize(w)) for w in words]
        new(Set(normalizedwords))
    end
end


Base.in(word::String, s::SwedishDictionary) = in(Word(normalize(word)), s.words)

export SwedishDictionary, Word, isanagram

end