using DataFrames

include("../types.jl")
include("../utilities.jl")
include("../topsis.jl")
include("../vikor.jl")
include("../electre.jl")
include("../moora.jl")

w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
Amat = [
      100 92 10 2 80 70 95 80 ;
      80  70 8  4 100 80 80 90 ;
      90 85 5 0 75 95 70 70 ; 
      70 88 20 18 60 90 95 85
    ]
dmat = makeDecisionMatrix(Amat)
result = moora(dmat, w) 


