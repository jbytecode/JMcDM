using DataFrames
using LinearAlgebra
using JuMP
using Cbc


include("../types.jl")
include("../utilities.jl")
include("../topsis.jl")
include("../vikor.jl")
include("../electre.jl")
include("../moora.jl")
include("../dematel.jl")
include("../ahp.jl")
include("../nds.jl")
include("../singlecriterion.jl")
include("../game.jl")
include("../dataenvelop.jl")
include("../grey.jl")
include("../saw.jl")
include("../aras.jl")


decmat = [4.0  7  3  2  2  2  2;
    4.0  4  6  4  4  3  7;
    7.0  6  4  2  5  5  3;
    3.0  2  5  3  3  2  5;
    4.0  2  2  5  5  3  6]

df = makeDecisionMatrix(decmat)

weights = [0.283, 0.162, 0.162, 0.07, 0.085, 0.162, 0.076]

fns = convert(Array{Function,1}, [maximum for i in 1:7])

result = saw(df, weights, fns)