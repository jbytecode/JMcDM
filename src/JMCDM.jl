module JMCDM

using DataFrames
using LinearAlgebra


# includes 
include("types.jl")
include("utilities.jl")
include("topsis.jl")
include("vikor.jl")
include("electre.jl")
include("moora.jl")
include("dematel.jl")
include("ahp.jl")
include("nds.jl")
include("singlecriteria.jl")

# export MCDM types
export MCDMResult
export TopsisResult
export VikorResult
export ElectreResult
export MooraResult
export AHPConsistencyResult
export AHPResult
export NDSResult

#  export SCDM types
export SCDMResult
export LaplaceResult
export MaximinResult
export MaximaxResult
export MinimaxResult
export MiniminResult

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
export dematel
export ahp_RI, ahp_consistency, ahp
export nds

#  export SCDM tools
export laplace
export maximin
export maximax
export minimax
export minimin

end # module
