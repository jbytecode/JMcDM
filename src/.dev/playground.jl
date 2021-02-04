using DataFrames
using LinearAlgebra

include("../types.jl")
include("../utilities.jl")
include("../topsis.jl")
include("../vikor.jl")
include("../electre.jl")
include("../moora.jl")
include("../dematel.jl")



K = [0 3 0 2 0 0 0 0 3 0;
                3 0 0 0 0 0 0 0 0 2;
                4 1 0 2 1 3 1 2 3 2;
                4 1 4 0 1 2 0 1 0 0;
                3 2 3 1 0 3 0 2 0 0;
                4 1 4 4 0 0 0 1 1 3;
                3 0 0 0 0 2 0 0 0 0;
                3 0 4 3 2 3 1 0 0 0;
                4 3 2 0 0 1 0 0 0 2;
                2 1 0 0 0 0 0 0 3 0]
dmat = makeDecisionMatrix(K)
result = dematel(dmat)



