module Gini

export gini, GiniResult

import ..MCDMResult

struct GiniResult <: MCDMResult
    decisionMatrix::Matrix
    giniCoefficients::Vector{Float64}
    w::Vector{Float64}
end

"""
    gini(decisionMat)

Calculate objective criterion weights using the Gini coefficient method.

# Arguments
- `decisionMat::Matrix`: An `m × n` matrix of objective values for `m`
  alternatives and `n` criteria.

# Description
For each criterion, `gini` calculates the mean pairwise absolute difference
divided by twice the squared number of alternatives and the criterion mean.
The resulting Gini coefficients quantify dispersion; they are normalized to
produce the objective weights.

# Output
- `::GiniResult`: Holds the original decision matrix, the Gini coefficients,
  and the normalized criterion weights in `w`.

# Examples
```julia-repl
julia> decisionMat = [1.0 2.0; 2.0 2.0; 3.0 8.0];

julia> result = gini(decisionMat);

julia> result.w
2-element Vector{Float64}:
 0.4
 0.6
```

# References

Öztaş, T., Adalı, E. A., Tuş, A., & Öztaş, G. Z. (2023). Ranking green
universities from MCDM perspective: MABAC with Gini coefficient-based
weighting method. *Process Integration and Optimization for Sustainability*,
7, 163-175. https://doi.org/10.1007/s41660-022-00281-z
"""
function gini(decisionMat::Matrix)::GiniResult
    alternatives, criteria = size(decisionMat)
    coefficients = zeros(Float64, criteria)

    for criterion = 1:criteria
        values = decisionMat[:, criterion]
        pairwiseDifference = sum(abs(values[i] - values[j])
            for i = 1:alternatives, j = 1:alternatives)
        coefficients[criterion] =
            pairwiseDifference / (2 * alternatives^2 * (sum(values) / alternatives))
    end

    w = coefficients ./ sum(coefficients)

    return GiniResult(decisionMat, coefficients, w)
end

end # end of module Gini
