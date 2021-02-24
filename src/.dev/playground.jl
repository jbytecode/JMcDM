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

df = DataFrame(
:age        => [6.0, 4, 12],
:size       => [140.0, 90, 140],
:price      => [150000.0, 100000, 75000],
:distance   => [950.0, 1500, 550],
:population => [1500.0, 2000, 1100]);

w  = [0.35, 0.15, 0.25, 0.20, 0.05];
fns = [minimum, maximum, minimum, minimum, maximum];

methods1 = [:topsis, :electre, :vikor, :moora, :cocoso, :wpm, :waspas]
methods2 = [:aras, :saw, :edas, :marcos, :mabac, :mairca, :grey]

result1 = summary(df, w, fns, methods1);
result2 = summary(df, w, fns, methods2);

@info result1
@info result2