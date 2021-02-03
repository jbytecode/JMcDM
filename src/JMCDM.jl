module JMCDM

using DataFrames

# includes 
include("types.jl")
include("utilities.jl")
include("topsis.jl")


# export types
export MCDMResult, TopsisResult

# export utility functions
export euclidean, normalize, colmaxs, colmins
export unitize 

#  export MCDM tools
export topsis 


end # module
