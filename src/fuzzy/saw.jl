struct FuzzySawResult
    decmat::Matrix
    normalized_decmat::Matrix
    weighted_normalized_decmat::Matrix
    scores::Vector
end



"""
    fuzzysaw(decmat::Matrix{FuzzyType}, w::Vector{FuzzyType}, fns; defuzzificationmethod::DefuzzificationMethod = WeightedMaximum(0.5))

# Description 

    Fuzzy SAW method for fuzzy decision making.

# Arguments
- `decmat`: A matrix of fuzzy numbers.
- `w`: A vector of weights.
- `fns`: A vector of functions (either maximum or minimum).
- `defuzzificationmethod`: The method used for defuzzification.

# Returns
- A FuzzySawResult object containing the normalized decision matrix, weighted normalized decision matrix, and scores.
"""
function fuzzysaw(
    decmat::Matrix{FuzzyType},
    w::Vector{FuzzyType},
    fns;
    defuzzificationmethod::DefuzzificationMethod = WeightedMaximum(0.5),
)::FuzzySawResult where {FuzzyType<:FuzzyNumber}

    n, p = size(decmat)

    normalized_mat = similar(decmat)
    weightednormalized_mat = similar(decmat)

    for j = 1:p
        if fns[j] == maximum
            cvalues = map(last, decmat[:, j])
            colmax = maximum(cvalues)
            normalized_mat[:, j] = decmat[:, j] ./ colmax
        elseif fns[j] == minimum
            avalues = map(first, decmat[:, j])
            colmin = minimum(avalues)
            normalized_mat[:, j] = colmin ./ decmat[:, j]
        else
            throw(UndefinedDirectionException("fns[i] should be either minimum or maximum, but $(fns[j]) found."))
        end
    end

    for j = 1:p
        weightednormalized_mat[:, j] .= w[j] .* normalized_mat[:, j]
    end

    scores = zeros(Float64, n)

    for i = 1:n
        scores[i] =
            sum(weightednormalized_mat[i, :]) |>
            x -> defuzzification(x, defuzzificationmethod)
    end


    result = FuzzySawResult(decmat, normalized_mat, weightednormalized_mat, scores)

    return result
end
