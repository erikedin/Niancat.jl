module Languages

struct Word
    w::String
end

function normalize(s::String) :: String
    normword = uppercase(s)

    normword
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