module JMcDM


# Dependencies
using Requires


# Modules Game, DataEnvelop, and SECA are activated
# whenever the JuMP and Ipopt packages are required
# manually by the user.
export game, dataenvelop

function __init__()
    @require Ipopt = "b6b21f68-93f8-5de0-b562-5493be1d77c9" begin
        @require JuMP = "4076af6c-e467-56ae-b986-b466b2749572" begin
            include("game.jl")
            import .Game: game, GameResult
            export GameResult

            include("seca.jl")
            import .SECA: seca, SECAResult, SECAMethod
            export SECAMethod
            export SECAResult
            export seca

            include("dataenvelop.jl")
            import .DataEnvelop: dataenvelop, DataEnvelopResult
            export DataEnvelopResult

            include("bestworst.jl")
            import .BestWorstMethod: bestworst, BestWorstResult
            export bestworst 
            export BestWorstResult
        end
    end
end

# Abstract Types
abstract type MCDMResult end
abstract type SCDMResult end
abstract type MCDMMethod end

"""
    struct MCDMSetting
        df::Matrix
        weights::Array{Float64, 1}
        fns::Array{Function, 1}
    end

    Immutable data structure for a MCDM setting.

# Arguments
- `df::Matrix`: The decision matrix in type of Matrix.
- `weights::Array{Float64,1}`: Array of weights for each criterion.
- `fns::Array{<:Function, 1}`: Array of functions. The elements are either minimum or maximum.

# Description
Many methods including Topsis, Electre, Waspas, etc., use a decision matrix, weights, and directions
of optimizations in types of Matrix and Vector, respectively. The type MCDMSetting simply
holds these information to pass them into methods easily. Once a MCDMSetting object is created, the problem
can be passed into several methods like topsis(setting), electre(setting), waspas(setting), etc.

# Examples

```julia-repl
julia> df = DataFrame();
julia> df[:, :x] = Float64[9, 8, 7];
julia> df[:, :y] = Float64[7, 7, 8];
julia> df[:, :z] = Float64[6, 9, 6];
julia> df[:, :q] = Float64[7, 6, 6];

julia> w = Float64[4, 2, 6, 8];

julia> fns = [maximum, maximum, maximum, maximum];

julia> setting = MCDMSetting(Matrix(df), w, fns)

julia> result = topsis(setting);
julia> # Same result can be obtained using
julia> result2 = mcdm(setting, TopsisMethod())
```

"""
struct MCDMSetting
    df::Matrix
    weights::Array{Float64,1}
    fns::Array{F,1} where {F<:Function}
end

# includes
include("greynumber.jl")
include("utilities.jl")
include("normalizations.jl")
include("topsis.jl")
include("vikor.jl")
include("electre.jl")
include("moora.jl")
include("dematel.jl")
include("ahp.jl")
include("nds.jl")
include("singlecriterion.jl")
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
include("merec.jl")
include("lopcow.jl")
include("ocra.jl")
include("lmaw.jl")
include("todim.jl")

include("summary.jl")

include("mcdm.jl")

include("sd.jl")
include("rov.jl")
include("piv.jl")
include("cilos.jl")
include("idocriw.jl")
include("ram.jl")

include("copeland.jl")

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
import .ARAS: aras, ArasMethod, ARASResult
import .COCOSO: cocoso, CocosoMethod, CoCoSoResult
import .CODAS: codas, CodasMethod, CODASResult
import .COPRAS: copras, CoprasMethod, COPRASResult
import .EDAS: edas, EdasMethod, EDASResult
import .CRITIC: critic, CRITICResult, CriticMethod
import .ELECTRE: electre, ElectreMethod, ElectreResult
import .DEMATEL: dematel, DematelResult
import .Entropy: entropy, EntropyResult
import .AHP: ahp, ahp_consistency, ahp_RI, AHPResult, AHPConsistencyResult
import .MEREC: merec, MERECResult, MERECMethod
import .PIV: piv, PIVResult, PIVMethod
import .LOPCOW: lopcow, LOPCOWResult, LOPCOWMethod
import .OCRA: ocra, OCRAResult, OCRAMethod
import .LMAW: lmaw, LMAWResult, LMAWMethod
import .TODIM: todim, TODIMResult, TODIMMethod
import .CILOS: cilos, CILOSResult
import .IDOCRIW: idocriw, IDOCRIWResult
import .RAM: ram, RAMResult, RAMMethod

import .SCDM: LaplaceResult, MaximinResult, MaximaxResult, MinimaxResult, MiniminResult
import .SCDM: SavageResult, HurwiczResult, MLEResult, ExpectedRegretResult
import .SCDM:
    laplace, maximax, maximin, minimax, minimin, savage, hurwicz, mle, expectedregret

import .GreyNumbers: GreyNumber, kernel, whitenizate, simplify, center, radius

import .Utilities: *
using .Utilities

# export imported functions
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
export ROVMethod
export MERECMethod
export PIVMethod
export LOPCOWMethod
export OCRAMethod
export LMAWMethod
export TODIMMethod
export RAMMethod


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
export MERECResult
export PIVResult
export LOPCOWResult
export OCRAResult
export LMAWResult
export TODIMResult
export CILOSResult
export IDOCRIWResult
export RAMResult

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


# export utility functions
export euclidean
export normalize
export colmaxs
export colmins
export unitize
export reverseminmax
export makegrey

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
export merec
export piv
export lopcow
export ocra
export lmaw
export todim
export cilos
export idocriw
export ram

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

#  export summary function
export summary
export mcdm

# export Copeland module
import JMcDM.Copeland: copeland
export copeland

# export Grey Number elements
export GreyNumber, kernel, whitenizate, simplify, center, radius

export Normalizations

end # module
