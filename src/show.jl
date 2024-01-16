using Plots
using LinearAlgebra

function plot_points(X, color=:green)
    p = scatter(X[1, :], X[2, :], X[3, :],
        color=color,
        marker=4,
        legend=false,
        axis=false,
        grid=false,
    )
    for i in 1:size(X, 2)-1
        plot!(p, [X[1, i], X[1, i+1]], [X[2, i], X[2, i+1]], [X[3, i], X[3, i+1]], color=:gray, lw=4)
    end
    p
end

function plot_points!(p, X, color=:green)
    scatter!(p, X[1, :], X[2, :], X[3, :],
        color=color,
        marker=4,
        legend=false,
        axis=false,
        grid=false,
    )
    for i in 1:size(X, 2)-1
        plot!(p, [X[1, i], X[1, i+1]], [X[2, i], X[2, i+1]], [X[3, i], X[3, i+1]], color=:gray, lw=4)
    end
    p
end
