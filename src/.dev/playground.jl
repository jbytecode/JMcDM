using DataFrames
using LinearAlgebra
using JuMP
using Cbc
using StatsBase

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
include("../mabac.jl")


decmat = [2 1 4 7 6 6 7 3000;
4 1 5 6 7 7 6 3500;
3 2 6 6 5 6 8 4000;
5 1 5 7 6 7 7 3000;
4 2 5 6 7 7 6 3000;
3 2 6 6 6 6 6 3500]

df = makeDecisionMatrix(decmat)

weights = [0.293, 0.427, 0.067, 0.027, 0.053, 0.027, 0.053, 0.053];

fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum];

result = mabac(df, weights, fns)