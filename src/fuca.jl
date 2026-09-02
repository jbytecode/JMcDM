module FUCA

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities: rowsums, unitize, weightise

export fuca, FucaMethod, FUCAResult

struct FucaMethod <: MCDMMethod end

struct FUCAResult <: MCDMResult
    decisionMat::Matrix
    weights::Vector{Float64}
    rankMatrix::Matrix{Float64}
    weightedRankMatrix::Matrix{Float64}
    scores::Vector{Float64}
    ranking::Vector{Int}
    ranks::Vector{Int}
    bestIndex::Int
end

function rankcolumn(values::AbstractVector, direction::Function)::Vector{Float64}
    order = if direction == maximum
        sortperm(values, rev=true)
    elseif direction == minimum
        sortperm(values)
    else
        error("Each function in dirs must be either minimum or maximum")
    end

    ranks = Vector{Float64}(undef, length(values))
    start = 1
    while start <= length(values)
        stop = start
        while stop < length(values) && values[order[stop + 1]] == values[order[start]]
            stop += 1
        end
        rank = (start + stop) / 2
        for position = start:stop
            ranks[order[position]] = rank
        end
        start = stop + 1
    end
    return ranks
end

"""
    fuca(decisionMat, weights, dirs)

Apply FUCA (Faire Un Choix Adéquat) to rank alternatives from a decision matrix.

# Arguments
- `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria.
- `weights::Array{Float64,1}`: m-vector of nonnegative criterion weights. The weights are normalized internally.
- `dirs::Array{<:Function,1}`: m-vector specifying `maximum` for benefit criteria and `minimum` for cost criteria.

# Description
FUCA ranks alternatives within every criterion, assigning rank 1 to the preferred
value and average ranks to ties. It multiplies each rank by its normalized criterion
weight and sums the weighted ranks. Lower scores are preferred.

# Output
- `::FUCAResult`: Holds the rank matrices, scores, final ascending ranking, and best alternative index.

# References
Shervin Zakeri, Prasenjit Chatterjee, Dimitri Konstantas, Fatih Ecer, A comparative analysis of 
simple ranking process and faire un Choix Adéquat method, Decision Analytics Journal, Volume 10,
2024, 100380, ISSN 2772-6622, https://doi.org/10.1016/j.dajour.2023.100380.
"""
function fuca(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    dirs::Array{F,1},
)::FUCAResult where {F<:Function}
    nalternatives, ncriteria = size(decisionMat)

    length(weights) == ncriteria || error("Length of weights must be equal to number of criteria")
    length(dirs) == ncriteria || error("Length of dirs must be equal to number of criteria")
    all(weight -> weight >= 0, weights) || error("Weights must be nonnegative")
    sum(weights) > 0 || error("At least one weight must be positive")

    w = Float64.(unitize(weights))
    rankMatrix = Matrix{Float64}(undef, nalternatives, ncriteria)
    @inbounds for j = 1:ncriteria
        rankMatrix[:, j] = rankcolumn(decisionMat[:, j], dirs[j])
    end

    weightedRankMatrix = Float64.(weightise(rankMatrix, w))
    scores = Float64.(rowsums(weightedRankMatrix))
    ranking = sortperm(scores)
    ranks = invperm(ranking)

    return FUCAResult(
        decisionMat,
        w,
        rankMatrix,
        weightedRankMatrix,
        scores,
        ranking,
        ranks,
        first(ranking),
    )
end

"""
    fuca(setting)

Apply FUCA (Faire Un Choix Adéquat) to an `MCDMSetting`.

# Arguments
- `setting::MCDMSetting`: Decision matrix, criterion weights, and criterion directions.

# Output
- `::FUCAResult`: Holds the rank matrices, scores, final ascending ranking, and best alternative index.
"""
function fuca(setting::MCDMSetting)::FUCAResult
    return fuca(setting.df, setting.weights, setting.fns)
end

end # module FUCA
