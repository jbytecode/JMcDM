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


decmat = [3	12.5	2	120	14	3;
5	15	3	110	38	4;
3	13	2	120	19	3;
4	14	2	100	31	4;
3	15	1.5	125	40	4]

df = makeDecisionMatrix(decmat)

weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

fns = [maximum, minimum, minimum, maximum, minimum, maximum]

result = wpm(df, weights, fns)
