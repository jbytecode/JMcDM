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


decmat = [5000 5 5300 450;
4500 5 5000 400;
4500 4 4700 400;
4000 4 4200 400;
5000 4 7100 500;
5000 5 5400 450;
5500 5 6200 500;
5000 4 5800 450]

df = makeDecisionMatrix(decmat)

weights = [0.25, 0.25, 0.25, 0.25];

fns = [maximum, maximum, minimum, minimum];

result = edas(df, weights, fns)
