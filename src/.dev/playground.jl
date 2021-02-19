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

@info "Statistics"
using Statistics


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
include("../critic.jl")

decmat = [12.9918 0.7264 -1.1009 1.598139592;
4.1201 5.8824 3.4483 1.021563567;
4.1039 0.0000 -0.5076 0.984469444]

df = makeDecisionMatrix(decmat)

#weights = [0.036, 0.192, 0.326, 0.326, 0.120];

fns = [maximum, maximum, minimum, maximum];

result = critic(df, fns)
