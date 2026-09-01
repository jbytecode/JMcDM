module RIM

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities: euclidean, unitize, weightise

export rim, RimMethod, RIMResult

struct RimMethod <: MCDMMethod
    ranges::Vector{Tuple{Float64,Float64}}
    referenceIdeals::Vector{Tuple{Float64,Float64}}
end

function RimMethod(ranges::AbstractVector{<:Tuple{<:Real,<:Real}},
                   referenceIdeals::AbstractVector{<:Tuple{<:Real,<:Real}})
    return RimMethod(
        [(Float64(lower), Float64(upper)) for (lower, upper) in ranges],
        [(Float64(lower), Float64(upper)) for (lower, upper) in referenceIdeals],
    )
end

struct RIMResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Vector{Float64}
    ranges::Vector{Tuple{Float64,Float64}}
    referenceIdeals::Vector{Tuple{Float64,Float64}}
    normalizedDecisionMatrix::Matrix{Float64}
    weightedNormalizedDecisionMatrix::Matrix{Float64}
    distanceToIdeal::Vector{Float64}
    distanceToOrigin::Vector{Float64}
    bestIndex::Int
    scores::Vector{Float64}
    ranking::Vector{Int}
end

function _validate_inputs(decisionMat, weights, ranges, referenceIdeals)
    nalternatives, ncriteria = size(decisionMat)
    nalternatives > 0 || error("decisionMat must contain at least one alternative")
    ncriteria > 0 || error("decisionMat must contain at least one criterion")
    all(isfinite, decisionMat) || error("decisionMat must contain only finite values")
    length(weights) == ncriteria || error("Length of weights must be equal to number of criteria")
    length(ranges) == ncriteria || error("Length of ranges must be equal to number of criteria")
    length(referenceIdeals) == ncriteria || error("Length of referenceIdeals must be equal to number of criteria")
    all(isfinite, weights) || error("weights must contain only finite values")
    all(>=(0), weights) || error("weights must be nonnegative")
    sum(weights) > 0 || error("weights must have a positive sum")

    @inbounds for j = 1:ncriteria
        lower, upper = ranges[j]
        idealLower, idealUpper = referenceIdeals[j]
        isfinite(lower) && isfinite(upper) || error("ranges[$j] must contain only finite values")
        isfinite(idealLower) && isfinite(idealUpper) || error("referenceIdeals[$j] must contain only finite values")
        lower < upper || error("ranges[$j] must have a lower bound smaller than its upper bound")
        idealLower <= idealUpper || error("referenceIdeals[$j] must have a lower bound no greater than its upper bound")
        lower <= idealLower && idealUpper <= upper ||
            error("referenceIdeals[$j] must be contained in ranges[$j]")
        all(value -> lower <= value <= upper, decisionMat[:, j]) ||
            error("decisionMat values for criterion $j must be contained in ranges[$j]")
    end
end

function _normalize(value::Real, range::Tuple{Float64,Float64},
                    referenceIdeal::Tuple{Float64,Float64})
    lower, upper = range
    idealLower, idealUpper = referenceIdeal

    if idealLower <= value <= idealUpper
        return 1.0
    elseif value < idealLower
        return 1.0 - (idealLower - value) / (idealLower - lower)
    else
        return 1.0 - (value - idealUpper) / (upper - idealUpper)
    end
end

"""
    rim(decisionMat, weights, ranges, referenceIdeals)

Apply the Reference Ideal Method (RIM) to rank alternatives against predefined
criterion ranges and reference-ideal intervals. Each range and ideal is a
`(lower, upper)` tuple; use equal bounds for a singleton reference ideal.

# Arguments
- `decisionMat::Matrix`: n x m matrix of objective values.
- `weights::Vector{Float64}`: m criterion weights. They are normalized internally.
- `ranges`: m `(lower, upper)` tuples containing the admissible criterion values.
- `referenceIdeals`: m `(lower, upper)` tuples contained in the corresponding ranges.

# Output
- `RIMResult`: The normalized and weighted matrices, distances, scores, ranking,
  and best alternative.

# Reference
E. Cables, M.T. Lamata, and J.L. Verdegay, "RIM-reference ideal method in
multicriteria decision making," Information Sciences 337-338 (2016), 1-10.
"""
function rim(
    decisionMat::Matrix,
    weights::AbstractVector{<:Real},
    ranges::AbstractVector{<:Tuple{<:Real,<:Real}},
    referenceIdeals::AbstractVector{<:Tuple{<:Real,<:Real}},
)::RIMResult
    method = RimMethod(ranges, referenceIdeals)
    _validate_inputs(decisionMat, weights, method.ranges, method.referenceIdeals)

    w = unitize(Float64.(weights))
    nalternatives, ncriteria = size(decisionMat)
    normalizedDecisionMatrix = Matrix{Float64}(undef, nalternatives, ncriteria)

    @inbounds for j = 1:ncriteria
        for i = 1:nalternatives
            normalizedDecisionMatrix[i, j] = _normalize(
                decisionMat[i, j], method.ranges[j], method.referenceIdeals[j])
        end
    end

    weightedNormalizedDecisionMatrix = weightise(normalizedDecisionMatrix, w)
    distanceToIdeal = Vector{Float64}(undef, nalternatives)
    distanceToOrigin = Vector{Float64}(undef, nalternatives)
    scores = Vector{Float64}(undef, nalternatives)

    @inbounds for i = 1:nalternatives
        weightedAlternative = weightedNormalizedDecisionMatrix[i, :]
        distanceToIdeal[i] = euclidean(weightedAlternative, w)
        distanceToOrigin[i] = euclidean(weightedAlternative)
        scores[i] = distanceToOrigin[i] / (distanceToIdeal[i] + distanceToOrigin[i])
    end

    ranking = sortperm(scores, rev=true)
    return RIMResult(
        decisionMat,
        w,
        method.ranges,
        method.referenceIdeals,
        normalizedDecisionMatrix,
        weightedNormalizedDecisionMatrix,
        distanceToIdeal,
        distanceToOrigin,
        first(ranking),
        scores,
        ranking,
    )
end

function rim(setting::MCDMSetting,
             ranges::AbstractVector{<:Tuple{<:Real,<:Real}},
             referenceIdeals::AbstractVector{<:Tuple{<:Real,<:Real}})::RIMResult
    return rim(setting.df, setting.weights, ranges, referenceIdeals)
end

function rim(setting::MCDMSetting, method::RimMethod)::RIMResult
    return rim(setting.df, setting.weights, method.ranges, method.referenceIdeals)
end

end # module RIM
