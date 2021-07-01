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
include("../mcdm.jl")
include("../print.jl")
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
include("../summary.jl")
include("../entropy.jl")
include("../codas.jl")

decmat =[60.000 0.400 2540 500 990
6.350 0.150 1016 3000 1041
6.800 0.100 1727.2 1500 1676
10.000 0.200 1000 2000 965
2.500 0.100 560 500 915
4.500 0.080 1016 350 508
3.000 0.100 1778 1000 920]

df = makeDecisionMatrix(decmat)

w  = [0.036, 0.192, 0.326, 0.326, 0.12];
fns = [maximum, minimum, maximum, maximum, maximum];

result = codas(df, w, fns)
#df = DataFrame(
#:age        => [6.0, 4, 12],
#:size       => [140.0, 90, 140],
#:price      => [150000.0, 100000, 75000],
#:distance   => [950.0, 1500, 550],
#:population => [1500.0, 2000, 1100]);



#methods1 = [:topsis, :electre, :vikor, :moora, :cocoso, :wpm, :waspas]
#methods2 = [:aras, :saw, :edas, :marcos, :mabac, :mairca, :grey]

# result1 = summary(df, w, fns, methods1);
# result2 = summary(df, w, fns, methods2);

# @info result1
# @info result2