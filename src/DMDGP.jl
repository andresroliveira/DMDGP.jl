module DMDGP

include("graph.jl")
export graph

include("sphere.jl")
export sphere, intersection_3_spheres

include("bp.jl")
export bp, loss

include("show.jl")
export plot_points, plot_points!

end
