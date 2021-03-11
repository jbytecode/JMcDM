module JMcDM

using DataFrames
using LinearAlgebra
using JuMP
using Cbc
using StatsBase
using Statistics


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
include("singlecriterion.jl")
include("game.jl")
include("dataenvelop.jl")
include("grey.jl")
include("saw.jl")
include("aras.jl")
include("wpm.jl")
include("waspas.jl")
include("edas.jl")
include("marcos.jl")
include("mabac.jl")
include("mairca.jl")
include("copras.jl")
include("promethee.jl")
include("cocoso.jl")
include("critic.jl")
include("entropy.jl")
include("codas.jl")


include("summary.jl")


# export MCDM types
export MCDMResult
export TopsisResult
export VikorResult
export ElectreResult
export MooraResult
export AHPConsistencyResult
export AHPResult
export NDSResult
export GreyResult
export SawResult
export ARASResult
export WPMResult
export WASPASResult
export EDASResult
export MARCOSResult
export MABACResult
export MAIRCAResult
export COPRASResult
export PrometheeResult
export CoCoSoResult
export CRITICResult
export EntropyResult
export CODASResult

# export game type
export GameResult

#  export SCDM types
export SCDMResult
export LaplaceResult
export MaximinResult
export MaximaxResult
export MinimaxResult
export MiniminResult
export SavageResult
export HurwiczResult
export MLEResult
export ExpectedRegretResult
export DataEnvelopResult


# export utility functions
export euclidean
export normalize
export colmaxs
export colmins
export unitize
export makeDecisionMatrix
export reverseminmax
export makeminmax

#  export MCDM tools
export topsis 
export vikor
export electre
export moora 
export dematel
export ahp_RI, ahp_consistency, ahp
export nds
export grey
export saw 
export aras
export wpm
export waspas
export edas
export marcos
export mabac
export mairca
export copras
export promethee, prometLinear, prometVShape, prometUsual, prometQuasi, prometLevel
export cocoso
export critic
export entropy
export codas

#  export SCDM tools
export laplace
export maximin
export maximax
export minimax
export minimin
export savage
export hurwicz
export mle
export expectedregret

# export game solver
export game

# export data envelop
export dataenvelop

#  export summary function
export summary

end # module
