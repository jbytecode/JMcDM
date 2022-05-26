module JMcDM

# Dependencies
import DataFrames: DataFrame, DataFrameRow
# import JuMP: @variable, @objective, @constraint
# import JuMP: Model, MOI, optimize!, JuMP, objective_value
# import GLPK

# for Pretty printing
# of MCDM results
import Base.show

# Abstract Types 
abstract type MCDMResult end 
abstract type SCDMResult end
abstract type MCDMMethod end 


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
include("psi.jl")
include("moosra.jl")

include("summary.jl")

include("mcdm.jl")
include("print.jl")

include("copeland.jl")
include("sd.jl")
include("rov.jl")

# imports from modules
import .Topsis: topsis, TopsisMethod, TopsisResult
import .WPM: wpm, WPMResult, WPMMethod
import .WASPAS: waspas, WASPASResult, WaspasMethod
import .VIKOR: vikor, VikorMethod, VikorResult
import .SD: sd, SDResult
import .SAW: saw, SawResult, SawMethod
import .ROV: rov, ROVMethod, ROVResult
import .PSI: psi, PSIMethod, PSIResult
import .PROMETHEE: promethee, PrometheeMethod, PrometheeResult 
import .PROMETHEE: prometLinear, prometVShape, prometUShape, prometQuasi, prometLevel
import .NDS: nds, NDSResult 
import .MOOSRA: moosra, MoosraResult, MoosraMethod
import .MOORA: moora, MooraMethod, MooraResult
import .MARCOS: marcos, MarcosMethod, MarcosResult
import .MAIRCA: mairca, MaircaMethod, MAIRCAResult 
import .MABAC: mabac, MABACResult, MabacMethod
import .GREY: grey, GreyMethod, GreyResult
import .Game: game, GameResult
import .DataEnvelop: dataenvelop, DataEnvelopResult
import .ARAS: aras, ArasMethod, ARASResult 
import .COCOSO: cocoso, CocosoMethod, CoCoSoResult
import .CODAS: codas, CodasMethod, CODASResult
import .COPRAS: copras, CoprasMethod, COPRASResult


import .Utilities: * 
using .Utilities

# export imported functions
export DataFrame
export Utilities

# export MCDM methods
export MCDMMethod 
export ArasMethod
export CocosoMethod
export CodasMethod
export CoprasMethod
export CriticMethod
export EdasMethod
export ElectreMethod
export GreyMethod
export MabacMethod
export MaircaMethod
export MooraMethod
export PrometheeMethod
export SawMethod
export TopsisMethod
export VikorMethod
export WPMMethod
export WaspasMethod
export MarcosMethod
export PSIMethod
export MoosraMethod

export MCDMSetting

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
export MarcosResult
export MABACResult
export MAIRCAResult
export COPRASResult
export PrometheeResult
export CoCoSoResult
export CRITICResult
export EntropyResult
export CODASResult
export SDResult
export ROVResult
export PSIResult
export MoosraResult

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
export promethee, prometLinear, prometVShape, prometUShape, prometQuasi, prometLevel
export cocoso
export critic
export entropy
export codas
export sd
export rov
export psi
export moosra

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
export mcdm

# export Copeland module
import JMcDM.Copeland: copeland
export copeland

end # module
