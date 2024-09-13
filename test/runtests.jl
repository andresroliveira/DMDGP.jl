using DMDGP
using DataFrames: DataFrame
using Test

@testset "DMDGP.jl" begin
    g = graph(
        DataFrame(
            u=[2, 1, 1, 1, 4, 3, 2, 1, 2, 3],
            v=[5, 3, 2, 4, 5, 5, 4, 5, 3, 4],
            duv=[3.1200058975, 2.4913895358, 1.526, 3.7369555042, 1.526, 2.4913895358, 2.4913895358, 4.0455072276, 1.526, 1.526]
        )
    )
    sol = bp(g)
    @test loss(g, sol.X) < 1e-6
end
