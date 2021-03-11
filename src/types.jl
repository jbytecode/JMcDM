abstract type MCDMResult end 
abstract type SCDMResult end

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
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    weightedDecisionMatrix::DataFrame
    referenceMatrix::DataFrame
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

