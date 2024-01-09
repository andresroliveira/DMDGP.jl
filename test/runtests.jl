using DMDGP
using Test

@testset "DMDGP.jl" begin
    g = graph("data/instance.csv")
    sol = bp(g)
    @test loss(g, sol.X) < 1e-6
end
