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
include("../wpm.jl")
include("../waspas.jl")
include("../edas.jl")
include("../marcos.jl")


decmat = [8.675 8.433 8.000 7.800 8.025 8.043;
8.825 8.600 7.420 7.463 7.825 8.229;
8.325 7.600 8.040 7.700 7.925 7.600;
8.525 8.667 7.180 7.375 7.750 8.071]

df = makeDecisionMatrix(decmat)

weights = [0.19019, 0.15915, 0.19819, 0.19019, 0.15115, 0.11111];

fns = [maximum, maximum, maximum, maximum, maximum, maximum];

Fns = convert(Array{Function, 1} , fns)

result = marcos(df, weights, Fns)