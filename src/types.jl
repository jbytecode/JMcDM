abstract type MCDMResult end 

struct TopsisResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    normalizedDecisionMatrix::DataFrame
    normalizedWeightedDecisionMatrix::DataFrame 
    bestIndex::Int64 
    scores::Array{Float64,1}
end

struct VikorResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    weightedDecisionMatrix::DataFrame
    bestIndex::Int64
    scores::Array{Float64,1}
end