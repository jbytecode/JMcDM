module CRADIS


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities: weightise, colmins, colmaxs, rowsums

struct CradisMethod <: MCDMMethod
    normalization::G where {G<:Function}
end

CradisMethod() = CradisMethod(Normalizations.dividebycolumnmaxminnormalization)

const CRADISMethod = CradisMethod

struct CRADISResult <: MCDMResult
    decisionMat::Matrix
    normalizedDecisionMat::Matrix
    weights::Vector{Float64}
    weightedNormalizedDecisionMat::Matrix{Float64}
    tideal::Float64
    tantiideal::Float64
    idealAlternative::Vector{Float64}
    antiIdealAlternative::Vector{Float64}
    dplus::Matrix{Float64}
    dminus::Matrix{Float64}
    splus::Vector{Float64}
    sminus::Vector{Float64}
    splus0::Float64
    sminus0::Float64
    kplus::Vector{Float64}
    kminus::Vector{Float64}
    q::Vector{Float64}
    scores::Vector{Float64}
    ranking::Vector{Int64}
    bestIndex::Int64
end

export cradis, CRADISMethod, CRADISResult



"""

    cradis(decisionMat, weights, fs; normalization) 


# Description

The CRADIS (Criteria Ranking and Decision Support) method is a multi-criteria decision-making 
technique that evaluates alternatives based on multiple criteria. It normalizes the decision 
matrix, applies weights to the criteria, and calculates scores for each alternative to determine 
their ranking.

# Arguments

- `decisionMat::Matrix`: A matrix representing the decision matrix, where rows correspond to 
  alternatives and columns correspond to criteria.
- `weights::Array{Float64,1}`: An array of weights for each criterion, indicating their relative
  importance.
- `fs::Array{F,1}`: An array of functions that define the direction of optimization for each criterion 
  (e.g., `maximum` for benefit criteria, `minimum` for cost criteria).
- `normalization::G`: An optional normalization function to be applied to the decision matrix.
  Default is `Normalizations.dividebycolumnmaxminnormalization`.

# References 

- Puška, A., I. Hodžić, and A. Štilić. "Evaluating the knowledge economies within the European 
  Union: A global knowledge index ranking via entropy and CRADIS methodologies." International 
  Journal of Knowledge and Innovation Studies 1.2 (2023): 103-115.
"""
function cradis(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fs::Array{F,1};
    normalization::G=Normalizations.dividebycolumnmaxminnormalization)::CRADISResult where {F<:Function,G<:Function}

    n, p = size(decisionMat)

    normalizedDecisionMat = normalization(decisionMat, fs)

    weightedNormalizedDecisionMat = weightise(normalizedDecisionMat, weights)

    t_ideal = maximum(weightedNormalizedDecisionMat)
    t_anti_ideal = minimum(weightedNormalizedDecisionMat)

    idealAlternative = colmaxs(weightedNormalizedDecisionMat)
    antiIdealAlternative = colmins(weightedNormalizedDecisionMat)

    dplus = t_ideal .- weightedNormalizedDecisionMat
    dminus = weightedNormalizedDecisionMat .- t_anti_ideal

    splus = rowsums(dplus)
    sminus = rowsums(dminus)

    splus0 = sum(t_ideal .- idealAlternative)
    sminus0 = sum(idealAlternative .- t_anti_ideal)

    kplus = splus0 ./ splus
    kminus = sminus ./ sminus0

    q = (kplus .+ kminus) ./ 2
    ranking = sortperm(q)
    bestIndex = ranking |> last

    return CRADISResult(
        decisionMat,
        normalizedDecisionMat,
        weights,
        weightedNormalizedDecisionMat,
        t_ideal,
        t_anti_ideal,
        idealAlternative,
        antiIdealAlternative,
        dplus,
        dminus,
        splus,
        sminus,
        splus0,
        sminus0,
        kplus,
        kminus,
        q,
        q,
        ranking,
        bestIndex)

end

function cradis(setting::MCDMSetting; normalization::G=Normalizations.dividebycolumnmaxminnormalization)::CRADISResult where {G<:Function}
    cradis(setting.df, setting.weights, setting.fns, normalization=normalization)
end

end # end of module CRADIS