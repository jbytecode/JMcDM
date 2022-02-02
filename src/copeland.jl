module Copeland

function level_of_dominance(v1::Array{Int,1}, v2::Array{Int,1})::Int64
    lod = zero(Int64)
    n = length(v1)
    for i = 1:n
        if v1[i] < v2[i]
            lod += 1
        end
    end
    return lod
end

function dominance_scores(ordering_mat::Array{Int, 2})::Array{Int, 2}
    n, _ = size(ordering_mat)
    lev_dom = zeros(Int64, n, n)
    for i in 1:n
        for j in 1:n
            lev_dom[i, j] = level_of_dominance(ordering_mat[i,:], ordering_mat[j,:])
        end
    end
    return lev_dom
end

function winloss_scores(dommat::Array{Int, 2})::Array{Int, 2}
    n, _ = size(dommat)
    winlossmat = zeros(Int64, n, n)
    for i in 1:n
        for j in 1:n 
            winlossmat[i, j] = Int(sign(dommat[i, j] - dommat[j, i]))
        end
    end
    return winlossmat
end

"""
        copeland(ordering_mat)

# Arguments
 - `ordering_mat`::Array{Int, 2}`: Ordering matrix.

# Description 
The function takes an ordering matrix as input. Different ordering results are in columns.
Orderings are in ascending order. The function returns the ranks. The alternative with rank 
1 is the winner. 

# Output 
- `::Array{Int, 1}`: Vector of ranks.
"""
function copeland(ordering_mat::Array{Int, 2})::Array{Int, 1}
    winlosses = ordering_mat |> dominance_scores |> winloss_scores
    n, _ = size(winlosses)
    scores = map(i -> Int(sum(winlosses[i, :])), 1:n)
    return scores
end

end # end of module