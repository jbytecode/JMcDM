module AROMAN

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Utilities: unitize, weightise

export aroman, AROMANMethod, AROMANResult

struct AROMANMethod <: MCDMMethod
    beta::Float64
    lambda::Float64
end

AROMANMethod(beta::Real=0.5, lambda::Real=0.5) =
    AROMANMethod(Float64(beta), Float64(lambda))

struct AROMANResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    linearNormalizedMatrix::Matrix
    vectorNormalizedMatrix::Matrix
    aggregatedNormalizedMatrix::Matrix
    weightedNormalizedMatrix::Matrix
    minimumSums::Vector
    maximumSums::Vector
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

"""
    aroman(decisionMat, weights, fns; beta = 0.5, lambda = 0.5)

Apply AROMAN (Alternative Ranking Order Method Accounting for Two-Step
Normalization) to a decision matrix.

# Arguments
- `decisionMat::Matrix`: n x m matrix of values for n alternatives and m criteria.
- `weights::Array{Float64,1}`: m-vector of criterion weights. Weights are normalized
  automatically when they do not sum to one.
- `fns::Array{<:Function,1}`: m-vector specifying `minimum` for cost criteria and
  `maximum` for benefit criteria.
- `beta::Real`: trade-off coefficient for the linear and vector normalizations.
- `lambda::Real`: coefficient balancing the summed cost and benefit values.

# Description
AROMAN normalizes each criterion using linear and vector normalization, aggregates
the two matrices, applies criterion weights, and separately sums cost and benefit
criteria. Higher scores indicate better alternatives.

# Examples
```julia-repl
julia> decisionMat = [40000.0 1200.0 1.4 8.0 9.0;
                       38500.0 1150.0 1.2 6.0 6.0;
                       39400.0 600.0 1.1 7.0 5.0;
                       48000.0 1300.0 1.6 10.0 12.0];

julia> weights = [0.28, 0.22, 0.26, 0.15, 0.09];

julia> result = aroman(decisionMat, weights, [minimum, maximum, maximum, maximum, maximum]);

julia> result.bestIndex
4
```

# References
Bošković, S., Švadlenka, L., Jovčić, S., Dobrodolac, M., Simić, V., & Bacanin, N.
(2023). An alternative ranking order method accounting for two-step normalization
(AROMAN)—A case study of the electric vehicle selection problem. IEEE Access, 11,
39496-39507.
"""
function aroman(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    beta::Real=0.5,
    lambda::Real=0.5,
)::AROMANResult where {F<:Function}
    nrows, ncols = size(decisionMat)

    nrows > 0 || throw(ArgumentError("decisionMat must contain at least one alternative"))
    ncols > 0 || throw(ArgumentError("decisionMat must contain at least one criterion"))
    length(weights) == ncols || throw(ArgumentError("weights must match the number of criteria"))
    length(fns) == ncols || throw(ArgumentError("fns must match the number of criteria"))
    0 <= beta <= 1 || throw(ArgumentError("beta must be between 0 and 1"))
    0 <= lambda <= 1 || throw(ArgumentError("lambda must be between 0 and 1"))
    all(fn -> fn == minimum || fn == maximum, fns) ||
        throw(ArgumentError("fns must contain only minimum or maximum"))
    sum(weights) != 0 || throw(ArgumentError("weights must not sum to zero"))

    matrix = Float64.(decisionMat)
    w = unitize(weights)
    linearNormalizedMatrix = similar(matrix)
    vectorNormalizedMatrix = similar(matrix)

    @inbounds for col = 1:ncols
        values = matrix[:, col]
        minimumValue = minimum(values)
        range = maximum(values) - minimumValue
        range != 0 || throw(ArgumentError("criterion $col must not have identical values"))

        norm = sqrt(sum(values .* values))
        norm != 0 || throw(ArgumentError("criterion $col must not have a zero vector norm"))

        linearNormalizedMatrix[:, col] = (values .- minimumValue) ./ range
        vectorNormalizedMatrix[:, col] = values ./ norm
    end

    aggregatedNormalizedMatrix =
        (beta .* linearNormalizedMatrix .+ (1 - beta) .* vectorNormalizedMatrix) ./ 2
    weightedNormalizedMatrix = weightise(aggregatedNormalizedMatrix, w)

    minimumSums = zeros(Float64, nrows)
    maximumSums = zeros(Float64, nrows)
    @inbounds for col = 1:ncols
        if fns[col] == minimum
            minimumSums .+= weightedNormalizedMatrix[:, col]
        else
            maximumSums .+= weightedNormalizedMatrix[:, col]
        end
    end

    scores = minimumSums .^ lambda .+ maximumSums .^ (1 - lambda)
    ranking = sortperm(scores)
    bestIndex = last(ranking)

    return AROMANResult(
        matrix,
        w,
        linearNormalizedMatrix,
        vectorNormalizedMatrix,
        aggregatedNormalizedMatrix,
        weightedNormalizedMatrix,
        minimumSums,
        maximumSums,
        scores,
        ranking,
        bestIndex,
    )
end

"""
    aroman(setting; beta = 0.5, lambda = 0.5)

Apply AROMAN to an `MCDMSetting`. Higher scores indicate better alternatives.
"""
function aroman(
    setting::MCDMSetting;
    beta::Real=0.5,
    lambda::Real=0.5,
)::AROMANResult
    aroman(setting.df, setting.weights, setting.fns, beta=beta, lambda=lambda)
end

end # module AROMAN
