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
include("../summary.jl")
include("../entropy.jl")

df = DataFrame(
    C1 = [2, 4, 3, 5, 4, 3],
    C2 = [1, 1, 2, 1, 2, 2],
    C3 = [4, 5, 6, 5, 5, 6],
    C4 = [7, 6, 6, 7, 6, 6],
    C5 = [6, 7, 5, 6, 7, 6],
    C6 = [6, 7, 6, 7, 7, 6],
    C7 = [7, 6, 8, 7, 6, 6],
    C8 = [3000, 3500, 4000, 3000, 3000, 3500]
    )

result = entropy(df)
#df = DataFrame(
#:age        => [6.0, 4, 12],
#:size       => [140.0, 90, 140],
#:price      => [150000.0, 100000, 75000],
#:distance   => [950.0, 1500, 550],
#:population => [1500.0, 2000, 1100]);

#w  = [0.35, 0.15, 0.25, 0.20, 0.05];
#fns = [minimum, maximum, minimum, minimum, maximum];

#methods1 = [:topsis, :electre, :vikor, :moora, :cocoso, :wpm, :waspas]
#methods2 = [:aras, :saw, :edas, :marcos, :mabac, :mairca, :grey]

# result1 = summary(df, w, fns, methods1);
# result2 = summary(df, w, fns, methods2);

# @info result1
# @info result2