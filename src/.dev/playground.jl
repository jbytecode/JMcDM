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



decmat = [2.50 240 57 45 1.10 0.333333;
2.50 285 60 75 4.00 0.428571;
4.50 320 100 65 7.50 1.111111;
4.50 365 100 90 7.50 1.111111;
5.00 400 100 90 11.00 1.111111;
2.50 225 60 45 1.10 0.333333;
2.50 270 57 60 4.00 0.428571;
4.50 330 100 70 7.50 1.111111;
4.50 365 100 80 7.50 1.111111;
5.00 380 110 65 8.00 1.111111;
2.50 285 65 80 4.00 0.400000;
4.00 280 75 65 4.00 0.400000;
4.50 365 102 95 7.50 1.111111;
4.50 400 102 95 7.50 1.111111;
6.00 450 110 95 11.00 1.176471;
6.00 510 110 105 11.00 1.176471;
6.00 330 140 110 18.50 1.395349;
2.50 240 65 80 4.00 0.400000;
4.00 280 75 75 4.00 0.400000;
4.50 355 102 95 7.50 1.111111;
4.50 385 102 90 7.50 1.111111;
5.00 385 114 95 7.50 1.000000;
6.00 400 110 90 11.00 1.000000;
6.00 480 110 95 15.00 1.000000;
6.00 440 140 100 18.50 1.200000;
6.00 500 140 100 18.50 1.200000;
5.00 450 125 100 15.00 1.714286;
6.00 500 150 125 18.50 1.714286;
6.00 515 180 140 22.00 2.307692;
7.00 550 200 150 30.00 2.307692;
6.00 500 180 140 15.00 2.307692;
6.00 500 180 140 18.50 2.307692;
6.00 500 180 140 22.00 2.307692;
7.00 500 180 140 30.00 2.307692;
7.00 500 200 140 37.00 2.307692;
7.00 500 200 140 45.00 2.307692;
7.00 500 200 140 55.00 2.307692;
7.00 500 200 140 75.00 2.307692]

df = makeDecisionMatrix(decmat)

weights = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667];

fns = [maximum, maximum, maximum, maximum, maximum, minimum];

result = mairca(df, weights, fns)