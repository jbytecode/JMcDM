module SPOTIS


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities: weightise, colmins, colmaxs, rowsums, unitize

export spotis, SpotisMethod, SPOTISResult

struct SpotisMethod <: MCDMMethod
    lowerbounds::Vector{Float64}
    upperbounds::Vector{Float64}    
end

struct SPOTISResult <: MCDMResult
    decisionMat::Matrix
    normalizedDecisionMat::Matrix
    weights::Vector{Float64}
    weightedNormalizedDecisionMat::Matrix{Float64}
    scores::Vector{Float64}
    ranking::Vector{Int}
    bestIndex::Int
end


"""
    spotis(decisionMat, weights, dirs; lowerbounds=nothing, upperbounds=nothing)

# Description

Implements the SPOTIS Rank Reversal Free Method for Multi-Criteria Decision-Making Support

# Arguments 

- `decisionMat::Matrix`: The decision matrix in type of Matrix.
- `weights::Array{Float64,1}`: Array of weights for each criterion.
- `dirs::Array{<:Function,1}`: Array of functions. The elements are either minimum or maximum.
- `lowerbounds::Union{Nothing, Array{Float64,1}}`: Optional array of lower bounds for each criterion. If not provided, the minimum values of the decision matrix will be used.
- `upperbounds::Union{Nothing, Array{Float64,1}}`: Optional array of upper bounds for each criterion. If not provided, the maximum values of the decision matrix will be used.

# Reference:

- Dezert, Jean, et al. "The SPOTIS rank reversal free method for multi-criteria decision-making support." 2020 IEEE 23rd international conference on information fusion (FUSION). IEEE, 2020.
"""
function spotis(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    dirs::Array{F,1};
    lowerbounds::Union{Nothing, Array{Float64,1}}=nothing,
    upperbounds::Union{Nothing, Array{Float64,1}}=nothing)::SPOTISResult where {F<:Function}

    nalternatives, ncriteria = size(decisionMat)

    if length(weights) != ncriteria
        error("Length of weights must be equal to number of criteria")
    end

    if length(dirs) != ncriteria
        error("Length of dirs must be equal to number of criteria")
    end

    w = unitize(weights)

    if lowerbounds === nothing
        lowerbounds = colmins(decisionMat)
    end
    if upperbounds === nothing
        upperbounds = colmaxs(decisionMat)
    end

    if length(lowerbounds) != ncriteria || length(upperbounds) != ncriteria
        error("Length of lowerbounds/upperbounds must be equal to number of criteria")
    end

    normalizedDecisionMat = Array{Float64}(undef, nalternatives, ncriteria)

    @inbounds for j = 1:ncriteria
        lower = lowerbounds[j]
        upper = upperbounds[j]

        if upper < lower
            error("upperbounds[$j] must be greater than or equal to lowerbounds[$j]")
        end

        ideal = if dirs[j] == minimum
            lower
        elseif dirs[j] == maximum
            upper
        else
            error("Each function in dirs must be either minimum or maximum")
        end

        span = upper - lower
        for i = 1:nalternatives
            normalizedDecisionMat[i, j] = if iszero(span)
                0.0
            else
                abs(decisionMat[i, j] - ideal) / span
            end
        end
    end

    weightedNormalizedDecisionMat = weightise(normalizedDecisionMat, w)
    scores = rowsums(weightedNormalizedDecisionMat)
    ranking = sortperm(scores)
    bestIndex = first(ranking)

    return SPOTISResult(
        decisionMat,
        normalizedDecisionMat,
        w,
        weightedNormalizedDecisionMat,
        scores,
        ranking,
        bestIndex)
end



function spotis(
    setting::MCDMSetting;
    lowerbounds::Union{Nothing, Array{Float64,1}}=nothing,
    upperbounds::Union{Nothing, Array{Float64,1}}=nothing)::SPOTISResult

    return spotis(
        setting.df,
        setting.weights,
        setting.fns,
        lowerbounds=lowerbounds,
        upperbounds=upperbounds,
    )
end




end # end of module SPOTIS