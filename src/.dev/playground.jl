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


mat = [-2 6 3 6 2;
        3 -4 7 12 1;
        -1 2 4 1 3;
        2 -1 3 2 1;
        ] 


mat = [-2 6 3;
        3 -4 7;
        -1 2 4]
 

        
mat = [0 -1 1;
      1 0 -1;
       -1 1 0]



dm = makeDecisionMatrix(mat)
result = game(dm)