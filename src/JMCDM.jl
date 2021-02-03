module JMCDM

using DataFrames

# includes 
include("types.jl")
include("utilities.jl")
include("topsis.jl")
include("vikor.jl")


# export types
export MCDMResult, TopsisResult

# export utility functions
export euclidean, normalize, colmaxs, colmins
export unitize, makeDecisionMatrix

#  export MCDM tools
export topsis 
export vikor

end # module
