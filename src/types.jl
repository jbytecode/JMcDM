abstract type MCDMResult end 
abstract type SCDMResult end
abstract type MCDMMethod end 


"""
    struct MCDMSetting 
        df::DataFrame
        weights::Array{Float64, 1}
        fns::Array{Function, 1}
    end

    Immutable data structure for a MCDM setting.

# Arguments
- `df::DataFrame`: The decision matrix in type of DataFrame.
- `weights::Array{Float64,1}`: Array of weights for each criterion.
- `fns::Array{Function, 1}`: Array of functions. The elements are either minimum or maximum.

# Description 
Many methods including Topsis, Electre, Waspas, etc., use a decision matrix, weights, and directions
of optimizations in types of DataFrame, Vector, and Vector, respectively. The type MCDMSetting simply
holds these information to pass them into methods easly. Once a MCDMSetting object is created, the problem
can be passed into several methods like topsis(setting), electre(setting), waspas(setting), etc.  

# Examples

```julia-repl
julia> df = DataFrame();
julia> df[:, :x] = Float64[9, 8, 7];
julia> df[:, :y] = Float64[7, 7, 8];
julia> df[:, :z] = Float64[6, 9, 6];
julia> df[:, :q] = Float64[7, 6, 6];

julia> w = Float64[4, 2, 6, 8];

julia> fns = makeminmax([maximum, maximum, maximum, maximum]);

julia> setting = MCDMSetting(df, w, fns)

julia> result = topsis(setting);
julia> # Same result can be obtained using
julia> result2 = mcdm(setting, TopsisMethod())
```

"""
struct MCDMSetting 
    df::DataFrame
    weights::Array{Float64, 1}
    fns::Array{Function, 1}
end

struct PSIResult <: MCDMResult
    scores::Array{Float64,1}
    rankings::Array{Int, 1}
    bestIndex::Int
end

struct TopsisResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    normalizedDecisionMatrix::DataFrame
    normalizedWeightedDecisionMatrix::DataFrame 
    bestIndex::Int64 
    scores::Array{Float64,1}
end

struct VikorResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    weightedDecisionMatrix::DataFrame
    bestIndex::Int64
    scores::Array{Float64,1}
end


struct ElectreResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    weightedDecisionMatrix::DataFrame
    fitnessTable::Array{Dict,1}
    nonfitnessTable::Array{Dict,1}
    fitnessMatrix::Array{Float64,2}
    nonfitnessMatrix::Array{Float64,2}
    C::Array{Float64,1}
    D::Array{Float64,1}
    bestIndex::Tuple
end


struct MooraResult <: MCDMResult
    mooraType::Symbol
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    weightedDecisionMatrix::DataFrame
    referenceMatrix::Union{DataFrame, Nothing}
    scores::Array{Float64,1}
    bestIndex::Int64
end


struct DematelResult <: MCDMResult
    comparisonMatrix::DataFrame
    NDMatrix::Array{Float64,2}
    relationShipMatrix::Array{Float64,2}
    c::Array{Float64,1}
    r::Array{Float64,1}
    c_plus_r::Array{Float64,1}
    c_minus_r::Array{Float64,1}
    threshold::Float64 
    influenceMatrix::Array{Float64,2}
    weights::Array{Float64,1}
end

struct AHPConsistencyResult <: MCDMResult
    comparisonMatrix::DataFrame
    normalizedComparisonMatrix::DataFrame
    consistencyVector::Array{Float64,1}
    priority::Array{Float64,1}
    pc::Array{Float64,1}
    lambda_max::Float64
    CI::Float64
    RI::Float64
    CR::Float64
    isConsistent::Bool
end

struct AHPResult <: MCDMResult
    comparisonMatrixList::Array{DataFrame,1}
    criteriaComparisonMatrix::DataFrame
    criteriaConsistency::AHPConsistencyResult
    decisionMatrix::DataFrame
    scores::Array{Float64,1}
    weights::Array{Float64,1}
    bestIndex::Int64
end

struct NDSResult <: MCDMResult
    ranks::Array{Int64,1}
    bestIndex::Int64
end

struct LaplaceResult <: SCDMResult
    expected_values::Array{Float64,1}
    bestIndex::Int64 
end

struct MaximinResult <: SCDMResult
    rowmins::Array{Float64,1}
    bestIndex::Int64
end


struct MaximaxResult <: SCDMResult
    rowmaxs::Array{Float64,1}
    bestIndex::Int64
end

struct MinimaxResult <: SCDMResult
    rowmaxs::Array{Float64,1}
    bestIndex::Int64
end

struct MiniminResult <: SCDMResult
    rowmins::Array{Float64,1}
    bestIndex::Int64
end

struct SavageResult <: SCDMResult
    regretMatrix::DataFrame
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct HurwiczResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct MLEResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct ExpectedRegretResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct GameResult <: MCDMResult
    row_player_probabilities::Array{Float64,1}
    value::Float64
end

struct DataEnvelopResult <: MCDMResult
    efficiencies::Array{Float64,1}
    references::DataFrame
    orderedcases::Array{Symbol,1}
end

struct GreyResult <: MCDMResult
    referenceRow::Array{Float64,1}
    normalizedMat::Matrix
    absoluteValueMat::Matrix
    greyTable::Matrix
    scores::Array{Float64,1}
    ordering::Array{Int64,1}
    bestIndex::Int64             
end

struct SawResult <: MCDMResult
    decisionMatrix::DataFrame
    normalizedDecisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct ARASResult <: MCDMResult
    referenceRow::Array{Float64,1}
    extendMat::Array{Float64,2}
    normalizedMat::Array{Float64,2}
    optimalitydegrees::Array{Float64,1}
    scores::Array{Float64,1}
    orderings::Array{Int64,1}
    bestIndex::Int64
end

struct WPMResult <: MCDMResult
    decisionMatrix::DataFrame
    normalizedDecisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct WASPASResult <: MCDMResult
    decisionMatrix::DataFrame
    normalizedDecisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct EDASResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct MARCOSResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct MABACResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct MAIRCAResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct COPRASResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end


struct PrometheeResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct CoCoSoResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct CRITICResult <: MCDMResult
    decisionMatrix::DataFrame
    w::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct EntropyResult <: MCDMResult
    decisionMatrix::DataFrame
    w::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct CODASResult <: MCDMResult
    decisionMatrix::DataFrame
    w::Array{Float64,1}
    scores::Array{Float64,1}
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct SDResult <: MCDMResult
    weights::Array{Float64, 1}
end

struct ROVResult 
    uminus::Array{Float64, 1}
    uplus::Array{Float64, 1}
    scores::Array{Float64, 1}
    ranks::Array{Float64, 1}
end


struct TopsisMethod <: MCDMMethod end

struct ElectreMethod <: MCDMMethod 
end 


struct ArasMethod <: MCDMMethod 
end 


struct CocosoMethod <: MCDMMethod
    lambda::Float64
end

CocosoMethod()::CocosoMethod = CocosoMethod(0.5)

struct CodasMethod <: MCDMMethod
    tau::Float64
end

CodasMethod()::CodasMethod = CodasMethod(0.02)

struct CoprasMethod <: MCDMMethod 
end 


struct CriticMethod <: MCDMMethod 
end 


struct EdasMethod <: MCDMMethod 
end 


struct GreyMethod <: MCDMMethod 
    zeta::Float64
end 

GreyMethod() :: GreyMethod = GreyMethod(0.5)

struct MabacMethod <: MCDMMethod 
end 


struct MaircaMethod <: MCDMMethod 
end 

struct PSIMethod <: MCDMMethod
end


struct MooraMethod <: MCDMMethod 
    method::Symbol
end 

MooraMethod() :: MooraMethod = MooraMethod(:reference)

struct PrometheeMethod <: MCDMMethod 
    pref::Array{Function, 1}
    qs::Array{Union{Nothing, Float64}, 1}
    ps::Array{Union{Nothing, Float64}, 1}
end 

PrometheeMethod(pref::Array{Function, 1}, qs::Array{Float64,1}, ps::Array{Float64, 1}) :: PrometheeMethod = PrometheeMethod(pref, qs, ps)

struct SawMethod <: MCDMMethod 
end 


struct VikorMethod <: MCDMMethod
    v::Float64
end 

VikorMethod()::VikorMethod = VikorMethod(0.5)


struct WaspasMethod <: MCDMMethod
    lambda::Float64
end

WaspasMethod() :: WaspasMethod = WaspasMethod(0.5)

struct WPMMethod <: MCDMMethod
end 


struct MarcosMethod <: MCDMMethod
end

struct ROVMethod <: MCDMMethod
end