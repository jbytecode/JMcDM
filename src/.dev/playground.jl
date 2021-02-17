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
include("../promethee.jl")


decmat = [6.952 8.000 6.649 7.268 8.000 7.652 6.316;
7.319 7.319 6.604 7.319 8.000 7.652 5.313;
7.000 7.319 7.652 6.952 7.652 6.952 4.642;
7.319 6.952 6.649 7.319 7.652 6.649 5.000]

df = makeDecisionMatrix(decmat)

weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140];

fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum];

result = mairca(df, weights, fns)