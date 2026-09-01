module ERVD

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations
using ..Utilities: colmaxs, colmins, unitize

export ervd, ERVDMethod, ERVDResult

struct ERVDMethod <: MCDMMethod
    referencePoints::Vector{Float64}
    lambda::Float64
    alpha::Float64
    normalization::G where {G<:Function}
end

ERVDMethod(
    referencePoints::Vector{Float64};
    lambda::Float64=2.25,
    alpha::Float64=0.88,
    normalization::G=Normalizations.dividebycolumnsumnormalization,
) where {G<:Function} = ERVDMethod(referencePoints, lambda, alpha, normalization)

struct ERVDResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Vector{Float64}
    referencePoints::Vector{Float64}
    normalizedDecisionMatrix::Matrix
    normalizedReferencePoints::Vector{Float64}
    valueDecisionMatrix::Matrix
    idealDesired::Vector{Float64}
    idealUndesired::Vector{Float64}
    distanceToIdeal::Vector{Float64}
    distanceToNegative::Vector{Float64}
    scores::Vector{Float64}
    ranking::Vector{Int64}
    bestIndex::Int64
end

"""
    ervd(decisionMat, weights, fns, referencePoints; lambda=2.25, alpha=0.88, normalization)

Apply the ERVD (Election based on Relative Value Distances) method for a given
matrix, weights, criterion directions, and decision-maker reference points.

# Arguments:
- `decisionMat::Matrix`: n x m matrix of objective values for n alternatives and m criteria.
- `weights::Array{Float64,1}`: m-vector of weights that sum to 1.0. If not, it is normalized.
- `fns::Array{<:Function,1}`: m-vector containing `maximum` for benefit and `minimum` for cost criteria.
- `referencePoints::Vector{Float64}`: m-vector of reference points, one for each criterion.
- `lambda::Float64`: Loss-aversion coefficient. The default is 2.25.
- `alpha::Float64`: Diminishing-sensitivity coefficient. The default is 0.88.
- `normalization{<:Function}`: Optional normalization function. Defaults to
  `Normalizations.dividebycolumnsumnormalization`, as prescribed in the ERVD paper.

# Description
ervd() converts criterion ratings to prospect-theory values relative to the supplied
reference points. It then finds the ideal and negative-ideal value solutions and ranks
alternatives by relative closeness using weighted absolute distances. Benefit criteria use
the increasing value function and cost criteria use the decreasing value function.

# Output
- `::ERVDResult`: Holds normalized and value-based matrices, ideal solutions, distances,
  scores, ranking, and best index.

# Examples
```julia-repl
julia> decisionMat = Float64[80 70; 90 60; 70 80];

julia> result = ervd(
           decisionMat,
           Float64[0.5, 0.5],
           [maximum, maximum],
           Float64[80, 70],
       );

julia> result.bestIndex
1
```

# References
Shyur, H.-j., Yin, L., Shih, H.-s., & Cheng, C.-b. (2015). A multiple criteria decision
making method based on relative value distances. Foundations of Computing and Decision
Sciences, 40(4), 299-314. https://doi.org/10.1515/fcds-2015-0017
"""
function ervd(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1},
    referencePoints::Vector{Float64};
    lambda::Float64=2.25,
    alpha::Float64=0.88,
    normalization::G=Normalizations.dividebycolumnsumnormalization,
)::ERVDResult where {F<:Function,G<:Function}
    nalternatives, ncriteria = size(decisionMat)

    length(weights) == ncriteria || error("Length of weights must be equal to number of criteria")
    length(fns) == ncriteria || error("Length of fns must be equal to number of criteria")
    length(referencePoints) == ncriteria || error("Length of referencePoints must be equal to number of criteria")
    lambda > 0 || error("lambda must be greater than zero")
    alpha > 0 || error("alpha must be greater than zero")
    all(fn -> fn == maximum || fn == minimum, fns) ||
        error("Each function in fns must be either minimum or maximum")

    w = unitize(weights)
    normalizedDecisionMatrix = normalization(decisionMat, fns)
    normalizedReferencePoints = referencePoints ./ vec(sum(decisionMat, dims=1))
    valueDecisionMatrix = Matrix{Float64}(undef, nalternatives, ncriteria)

    @inbounds for j = 1:ncriteria
        for i = 1:nalternatives
            difference = normalizedDecisionMatrix[i, j] - normalizedReferencePoints[j]
            if fns[j] == maximum
                valueDecisionMatrix[i, j] =
                    difference > 0 ? difference^alpha : -lambda * (-difference)^alpha
            else
                valueDecisionMatrix[i, j] =
                    difference < 0 ? (-difference)^alpha : -lambda * difference^alpha
            end
        end
    end

    idealDesired = Float64.(colmaxs(valueDecisionMatrix))
    idealUndesired = Float64.(colmins(valueDecisionMatrix))
    distanceToIdeal = Vector{Float64}(undef, nalternatives)
    distanceToNegative = Vector{Float64}(undef, nalternatives)

    @inbounds for i = 1:nalternatives
        distanceToIdeal[i] = sum(w .* abs.(valueDecisionMatrix[i, :] .- idealDesired))
        distanceToNegative[i] = sum(w .* abs.(valueDecisionMatrix[i, :] .- idealUndesired))
    end

    scores = distanceToNegative ./ (distanceToIdeal .+ distanceToNegative)
    ranking = Int64.(sortperm(scores, rev=true))
    bestIndex = first(ranking)

    return ERVDResult(
        decisionMat,
        w,
        referencePoints,
        normalizedDecisionMatrix,
        normalizedReferencePoints,
        valueDecisionMatrix,
        idealDesired,
        idealUndesired,
        distanceToIdeal,
        distanceToNegative,
        scores,
        ranking,
        bestIndex,
    )
end

"""
    ervd(setting, referencePoints; lambda=2.25, alpha=0.88, normalization)

Apply ERVD to an `MCDMSetting`.
"""
function ervd(
    setting::MCDMSetting,
    referencePoints::Vector{Float64};
    lambda::Float64=2.25,
    alpha::Float64=0.88,
    normalization::G=Normalizations.dividebycolumnsumnormalization,
)::ERVDResult where {G<:Function}
    return ervd(
        setting.df,
        setting.weights,
        setting.fns,
        referencePoints,
        lambda=lambda,
        alpha=alpha,
        normalization=normalization,
    )
end

end # End of module ERVD
