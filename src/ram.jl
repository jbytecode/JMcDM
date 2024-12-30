module RAM 


export ram, RAMResult, RAMMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities


struct RAMResult <: MCDMResult
    decisionMatrix::Matrix
    normalizedMatrix::Matrix
    weightedNormalizedMatrix::Matrix
    splusi::Vector
    sminusi::Vector
    sqrvals::Vector
    norRI::Vector
    ranks::Vector
    bestindex::Int
end

struct RAMMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

RAMMethod() = RAMMethod(Normalizations.dividebycolumnsumnormalization)


"""
    ram(decisionMat::Matrix, weights::Array{Float64,1}, fns::Array{F,1}; normalization::G = Normalizations.dividebycolumnsumnormalization) where {F<:Function, G<:Function}

Computes the Root Assessment Method (RAM) for the given decision matrix, weights, and functions.

# Arguments

- decisionMat::Matrix: A matrix of size n x m representing the decision matrix.
- weights::Array{Float64,1}: A vector of size m representing the weights of the criteria.
- fns::Array{F,1}: A vector of size m representing the functions of the criteria.

# Optional arguments

- normalization::G = Normalizations.dividebycolumnsumnormalization: A normalization function to be used. Default is dividebycolumnsumnormalization.

# Output

- RAMResult: A struct containing the following fields:
    - decisionMatrix::Matrix: The decision matrix.
    - normalizedMatrix::Matrix: The normalized decision matrix.
    - weightedNormalizedMatrix::Matrix: The weighted normalized decision matrix.
    - splusi::Vector: The s+ values for each alternative.
    - sminusi::Vector: The s- values for each alternative.
    - sqrvals::Vector: The square values for each alternative.
    - norRI::Vector: The normalized relative importance values for each alternative.
    - ranks::Vector: The ranks of the alternatives.
    - bestindex::Int: The index of the best alternative.

# References

- Sotoudeh-Anvari, Alireza. "Root Assessment Method (RAM): A novel multi-criteria decision 
making method and its applications in sustainability challenges." 
Journal of Cleaner Production 423 (2023): 138695.
"""
function ram(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.dividebycolumnsumnormalization
)::RAMResult where {F<:Function, G<:Function}

    n, m = size(decisionMat)

    normalized_decmat = normalization(decisionMat, fns)

    weighted_normalized_dec_mat = normalized_decmat .* weights'

    siplus = zeros(eltype(decisionMat), n)
    siminus = zeros(eltype(decisionMat), n)

    for i in 1:n 
        for j in 1:m 
            if fns[j] == minimum 
                siminus[i] += weighted_normalized_dec_mat[i, j]
            elseif fns[j] == maximum 
                siplus[i] += weighted_normalized_dec_mat[i, j]
            else 
                error("Invalid function type for criterion $j")
            end
        end
    end 

    function sqrfn(index)
        return (2.0 + siplus[index])^(1.0 / (2.0 + siminus[index]))
    end

    squarevals = map(sqrfn, 1:n)

    norRI = (squarevals .- minimum(squarevals))  ./ (maximum(squarevals) - minimum(squarevals))

    ranks = sortperm(norRI, rev = true) |> invperm

    bestindex = argmax(norRI)

    result = RAMResult(
        decisionMat,
        normalized_decmat,
        weighted_normalized_dec_mat,
        siplus,
        siminus,
        squarevals,
        norRI,
        ranks,
        bestindex
    )

    return result 
end # end of function ram


end # end of module RAM
