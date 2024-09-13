using Statistics: mean
include("sphere.jl")
include("graph.jl")

function initial_points(g::graph)
    X = zeros(Float32, 3, g.n)

    d12 = edge(g, 1, 2)
    d13 = edge(g, 1, 3)
    d23 = edge(g, 2, 3)

    cθ = (d12^2 + d23^2 - d13^2) / (2 * d12 * d23)
    sθ = sqrt(1 - cθ^2)

    X[:, 2] = [-d12, 0.0, 0.0]
    X[:, 3] = [-d12 + d23 * cθ, d23 * sθ, 0.0]

    return X
end

function loss(g::graph, X::Matrix{Float32}, u::Int)
    mean([
        (norm(X[:, u] - X[:, v])^2 - duv^2)^2
        for (v, duv) in g.adjacencies[u] if v < u
    ])
end

function loss(g::graph, X::Matrix{Float32})
    mean([
        (norm(X[:, u] - X[:, v])^2 - duv^2)^2
        for (u, v, duv) in g.edges
    ])
end

function next_point(g::graph, X, b::Int, u::Int)
    d1 = edge(g, u - 3, u)
    d2 = edge(g, u - 2, u)
    d3 = edge(g, u - 1, u)
    pp = intersection_3_spheres(
        sphere(X[:, u-3], d1),
        sphere(X[:, u-2], d2),
        sphere(X[:, u-1], d3)
    )
end

function bp(g::graph; δ=1e-4)
    n = g.n
    X = initial_points(g)
    branch = zeros(Int, n)
    visit = zeros(Int, n)

    visit[1:3] .= 1

    u = 4

    while u > 3
        visit[u] += 1
        pp = next_point(g, X, branch[u], u)
        X[:, u] = pp[branch[u]+1]
        err = loss(g, X, u)
        prune = err > δ

        if prune
            if branch[u] == 0
                branch[u] = 1

                for i in (u+1):n
                    branch[i] = 0
                end
            else
                while u > 3 && branch[u] == 1
                    u -= 1
                end
            end
        else
            if u == n
                return (X=X, branch=branch, visit=visit)
            else
                u += 1
            end
        end
    end


    error("Not find a solution!")
    nothing
end