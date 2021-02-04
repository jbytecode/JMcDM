using DataFrames
using LinearAlgebra

include("../types.jl")
include("../utilities.jl")
include("../topsis.jl")
include("../vikor.jl")
include("../electre.jl")
include("../moora.jl")
include("../dematel.jl")
include("../ahp.jl")


#= 
K = [
    1 7 1 / 5 1 / 8 1 / 2 1 / 3 1 / 5 1;
    1 / 7 1 1 / 8 1 / 9 1 / 4 1 / 5 1 / 9 1 / 8;
    5 8 1 1 / 3 4 2 1 1;
    8 9 3 1 7 5 3 3;
    2 4 1 / 4 1 / 7 1 1 / 2 1 / 5 1 / 5;
    3 5 1 / 2 1 / 5 2 1 1 / 3 1 / 3;
    5 9 1 1 / 3 5 3 1 1;
    1 8 1 1 / 3 5 3 1 1
]
dmat = makeDecisionMatrix(K)

result = ahp_consistency(dmat) =#

