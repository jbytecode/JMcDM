@info "Loading DataFrames"
using DataFrames

@info "Loading LinearAlgebra"
using LinearAlgebra

@info "Loading JuMP"
using JuMP

@info "Loading Cbc"
using Cbc

@info "Loading StatsBase"
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
include("../mairca.jl")
include("../copras.jl")
include("../promethee.jl")
include("../cocoso.jl")

decmat = [60.00 0.40 2540.00 500.00 990.00;
6.35 0.15 1016.00 3000.00 1041.00;
6.80 0.10 1727.20 1500.00 1676.00;
10.00 0.20 1000.00 2000.00 965.00;
2.50 0.10 560.00 500.00 915.00;
4.50 0.08 1016.00 350.00 508.00;
3.00 0.10 1778.00 1000.00 920.00]


df = makeDecisionMatrix(decmat)

weights = [0.036, 0.192, 0.326, 0.326, 0.120];

fns = [maximum, minimum, maximum, maximum, maximum];

lambda = 0.5;

result = cocoso(df, weights, fns, lambda)