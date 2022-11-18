module PIV

export piv, PIVResult, PIVMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities



struct PIVResult <: MCDMResult
    decisionMatrix::Matrix
    normalizedMatrix::Matrix
    weightedNormalizedMatrix::Matrix
    w::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct PIVMethod <: MCDMMethod end

function Base.show(io::IO, result::PIVResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best index:")
    println(io, result.bestIndex)
end

"""
    piv(decisionMat, weights, fs)
Apply PIV (Proximity Indexed Value) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fs::Array{<:Function,1}`: m-vector of type of criteria. The benefit criteria shown with "maximum", and the cost criteria shown with "minimum".

 # Description 
piv() applies the PIV method to rank n alternatives subject to m criteria and criteria type vector. Alternatives 
with lesser scores values (u_i values in the original article) are better as they represent the deviation 
from the ideal values.


# Output 
- `::PIVResult`: PIVResult object that holds multiple outputs including scores, rankings, and best index.

# References
Sameera Mufazzal, S.M. Muzakkir, A new multi-criterion decision making (MCDM) method based on proximity indexed value for minimizing rank reversals,
Computers & Industrial Engineering, Volume 119, 2018, Pages 427-438, ISSN 0360-8352,
https://doi.org/10.1016/j.cie.2018.03.045.
"""
function piv(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1},
)::PIVResult where {F<:Function}

    normalized_dec_mat = Utilities.normalize(decisionMat)
    weighted_norm_mat = Utilities.weightise(normalized_dec_mat, weights)

    nrow, ncol = size(weighted_norm_mat)

    desiredvalues = Utilities.apply_columns(fns, weighted_norm_mat)

    finalmat = similar(weighted_norm_mat)

    @inbounds for i = 1:nrow
        for j = 1:ncol
            if fns[j] == maximum
                finalmat[i, j] = desiredvalues[j] - weighted_norm_mat[i, j]
            elseif fns[j] == minimum
                finalmat[i, j] = weighted_norm_mat[i, j] - desiredvalues[j]
            end
        end
    end

    di = Utilities.apply_rows(sum, finalmat)

    ranks = di |> sortperm
    bestIndex = ranks |> first

    return PIVResult(
        decisionMat,
        normalized_dec_mat,
        weighted_norm_mat,
        weights,
        di,
        ranks,
        bestIndex,
    )
end

end # End of Module PIV 
