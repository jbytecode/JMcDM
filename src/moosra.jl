module MOOSRA

export moosra, MoosraMethod, MoosraResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities



struct MoosraMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

MoosraMethod() = MoosraMethod(Normalizations.dividebyallnormnormalization)

struct MoosraResult <: MCDMResult
    scores::Vector
    rankings::Array{Int,1}
    bestIndex::Int
end



"""
        moosra(decisionMat, weights, fns; lambda = 0.5, normalization)

Apply MOOSRA (Multi-Objective Optimization on the basis of Simple Ratio Analysis) for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alterntives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.
 - `normalization{<:Function}`: Optional normalization function.


# Description 
moosra() applies the MOOSRA method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MoosraResult`: MoosraResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [3        12.5        2        120        14        3;
       5        15        3        110        38        4;
       3        13        2        120        19        3;
       4        14        2        100        31        4;
       3        15        1.5        125        40        4]
5×6 Array{Float64,2}:
 3.0  12.5  2.0  120.0  14.0  3.0
 5.0  15.0  3.0  110.0  38.0  4.0
 3.0  13.0  2.0  120.0  19.0  3.0
 4.0  14.0  2.0  100.0  31.0  4.0
 3.0  15.0  1.5  125.0  40.0  4.0


julia> weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201];

julia> fns = [maximum, minimum, minimum, maximum, minimum, maximum];

julia> result = moosra(decmat, weights, fns, lambda);
```

# References
Das, Manik Chandra, Bijan Sarkar, and Siddhartha Ray. "Decision making under conflicting environment: a new MCDM method." 
International Journal of Applied Decision Sciences 5.2 (2012): 142-162.
"""
function moosra(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.dividebyallnormnormalization
)::MoosraResult where {F<:Function, G<:Function}

    mincounts = count(x -> x == minimum, fns)
    if mincounts < 1
        error(
            "At least one function (direction of optimization) must be the minimum function.",
        )
    end

    row, col = size(decisionMat)

    zerotype = eltype(decisionMat[1, :])

    # normalizedDecisionMat = dmat ./ sqrt(sum(dmat .* dmat))
    normalizedDecisionMat = normalization(decisionMat, fns)

    w = unitize(weights)

    weightedNormalizedMatrix = similar(normalizedDecisionMat)
    for i = 1:row
        weightedNormalizedMatrix[i, :] = normalizedDecisionMat[i, :] .* w
    end

    scores = zeros(zerotype, row)

    for i = 1:row
        positive = 0.0
        negative = 0.0
        for j = 1:col
            if fns[j] == maximum
                positive += weightedNormalizedMatrix[i, j]
            elseif fns[j] == minimum
                negative += weightedNormalizedMatrix[i, j]
            else
                error("fns[i] is not a proper function (direction of optimization)")
            end
        end
        scores[i] = positive / negative
    end

    orderings = scores |> sortperm
    bestIndex = orderings |> last

    result = MoosraResult(scores, orderings, bestIndex)

    return result
end


"""
        moosra(setting)

Apply MOOSRA (Multi-Objective Optimization on the basis of Simple Ratio Analysis) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
"""
function moosra(setting::MCDMSetting)::MoosraResult
    moosra(setting.df, setting.weights, setting.fns)
end

end # end of module MOOSRA 
