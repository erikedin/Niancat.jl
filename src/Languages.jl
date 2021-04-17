module Languages

struct SwedishDictionary
    words::Vector{String}

    SwedishDictionary(words::AbstractVector{<:String}) = new([String(w) for w in words])
end

Base.iterate(s::SwedishDictionary) = iterate(s.words)
Base.iterate(s::SwedishDictionary, state) = iterate(s.words, state)

struct Word
    w::String
end

export SwedishDictionary, Word

end