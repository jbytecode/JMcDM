module Borda

export borda 

"""
    borda(orderingMat::Matrix{Int})::Vector{Int}


# Description

The Borda count method is a voting system used to rank alternatives based on the preferences of voters.
In the context of multi-criteria decision making (MCDM), the Borda count method can be applied to aggregate 
rankings obtained from different methods or criteria. Each alternative receives points based on its position 
in each ranking, and the alternative with the lowest total points is considered the best choice.

# Arguments

- `orderingMat::Matrix{Int}`: A matrix of integers where each row represents a different ordering of alternatives. 
   Each column corresponds to rankings obtained by a particular method. Rankings are in ascending order, 
   meaning that a lower integer value indicates a better rank (e.g., 1 is the best rank, 2 is the second best, etc.).

# Returns

- `Vector{Int}`: A vector of integers representing the indices of alternatives sorted by their Borda scores. 
   The alternative with the lowest total score (best rank) will be at the beginning of the vector.
"""
function borda(orderingMat::Matrix{Int})::Vector{Int}
    numAlternatives, numMethods = size(orderingMat)
    scores = zeros(Int, numAlternatives)

    for i in 1:numAlternatives
        for j in 1:numMethods
            scores[i] += orderingMat[i, j]
        end
    end

    return sortperm(scores) # Return the indices of alternatives sorted by their Borda scores
end 

end # end of module Borda
