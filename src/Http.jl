module Http

abstract type HttpClient end

post(::HttpClient, uri::String, body::String) = error("Implement post in HttpClient subtypes")

struct RealHttpClient <: HttpClient end

# TODO Implement this
post(::RealHttpClient, uri::String, body::String) = nothing

export HttpClient, post
export RealHttpClient

end