module Http

using HTTP

abstract type HttpClient end

post(::HttpClient, uri::String, body::String) = error("Implement post in HttpClient subtypes")

struct RealHttpClient <: HttpClient end

function post(::RealHttpClient, uri::String, body::String)
    HTTP.request("POST", uri, [], body)

    nothing
end

export HttpClient, post
export RealHttpClient

end