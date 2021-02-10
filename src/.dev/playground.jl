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



x1 = [96.0, 84, 90, 81, 102, 83, 108, 99, 95]
x2 = [300.0, 282, 273, 270, 309, 285, 294, 288, 306]

out = [166.0, 150, 140, 136, 171, 144, 172, 170, 165]
inp = hcat(x1, x2)

result = dataenvelop(inp, out)