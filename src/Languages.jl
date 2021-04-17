module Languages

struct SwedishDictionary
    SwedishDictionary(::AbstractVector{<:String}) = new()
end

struct Word
    w::String
end

export SwedishDictionary, Word

end