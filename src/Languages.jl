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
    anagrams::Dict{String, Vector{String}}

    function SwedishDictionary(words::AbstractVector{<:String})
        normalizedwords = Word[]
        anagrams = Dict{String, Vector{String}}()
        for w in words
            nw = normalize(w)
            push!(normalizedwords, Word(nw))

            push!(get!(anagrams, sortword(nw), String[]), nw)
        end
        new(Set(normalizedwords), anagrams)
    end
end


Base.in(word::String, s::SwedishDictionary) = in(Word(normalize(word)), s.words)

findanagrams(dictionary::SwedishDictionary, s::String) = get(dictionary.anagrams, sortword(s), [])

normalizedword(::SwedishDictionary, word::String) :: String = normalize(word)

export SwedishDictionary, Word, isanagram, findanagrams, normalizedword

end