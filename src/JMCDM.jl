module JMCDM

using DataFrames

# includes 
include("types.jl")
include("utilities.jl")
include("topsis.jl")
include("vikor.jl")
include("electre.jl")
include("moora.jl")


# export types
export MCDMResult
export TopsisResult
export VikorResult
export ElectreResult
export MooraResult

# export utility functions
export euclidean
export normalize
export colmaxs
export colmins
export unitize
export makeDecisionMatrix

#  export MCDM tools
export topsis 
export vikor
export electre
export moora 

end # module
