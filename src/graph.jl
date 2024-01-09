using DataFrames: DataFrame
using CSV
const ValidSources = Union{Vector{UInt8},SubArray{UInt8,1,Vector{UInt8}},IO,Cmd,AbstractString}

struct graph
    n::Int64
    distance::Matrix{Float32}
    adjacencies::Vector{Vector{Any}}
    edges::Vector{Tuple{Int64,Int64,Float32}}
end

function graph(instance::DataFrame)
    n = max(maximum(instance.u), maximum(instance.v))
    distance = zeros(n, n)
    adjacencies = [[] for _ in 1:n]
    edges = Tuple{Int64,Int64,Float64}[]
    for (u, v, duv) in eachrow(instance)
        distance[u, v] = distance[v, u] = Float32(duv)
        push!(adjacencies[u], (v, Float32(duv)))
        push!(adjacencies[v], (u, Float32(duv)))
        push!(edges, (u, v, Float32(duv)))
    end
    graph(n, distance, adjacencies, edges)
end

graph(source::ValidSources) = graph(CSV.read(source, DataFrame))

function edge(g::graph, u::Int64, v::Int64)
    g.distance[u, v]
end