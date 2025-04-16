module COCOSO

export cocoso, CocosoMethod, CoCoSoResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities



struct CocosoMethod <: MCDMMethod
    lambda::Float64
    normalization::G where {G<:Function}
end

CocosoMethod()::CocosoMethod = CocosoMethod(0.5, Normalizations.maxminrangenormalization)

struct CoCoSoResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end



"""
        cocoso(decisionMat, weights, fns; lambda, normalization)

Apply CoCoSo (Combined Compromise Solution) method for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.
 - `lambda::Float64`: joint criterion. 0<=lambda<=1, default=0.5.
 - `normalization{<:Function}`: Optional normalization function.

# Description 
cocoso() applies the CoCoSo method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::CoCoSoResult`: CoCoSoResult object that holds multiple outputs including scores, rankings, and best index.

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

julia> result = cocoso(decmat, weights, fns, lambda = 0.5);

julia> result.scores
5-element Vector{Float64}:
 1.922475728710679
 1.8144169615649441
 1.8374089377955838
 2.1842047284481
 1.6232623861380282

julia> result.bestIndex
4
```
# References

Yazdani, M., Zarate, P., Kazimieras Zavadskas, E. and Turskis, Z. (2019), "A combined compromise solution (CoCoSo) method for multi-criteria decision-making problems", Management Decision, Vol. 57 No. 9, pp. 2501-2519. https://doi.org/10.1108/MD-05-2017-0458

"""
function cocoso(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.maxminrangenormalization,
    lambda::Float64 = 0.5,
)::CoCoSoResult where {F<:Function, G<:Function}

    row, col = size(decisionMat)
    w = unitize(weights)
    

    A = normalization(decisionMat, fns)

    scoreMat = similar(A)
    for i = 1:col
        scoreMat[:, i] = A[:, i] .^ w[i]
    end

    P = Vector{Any}(undef, row)
    for i = 1:row
        P[i] = sum(scoreMat[i, :])
    end

    # S = w * A |> rowsums
    S = Utilities.weightise(A, w) |> rowsums

    scoreTable = [S P]

    kA = (S .+ P) ./ sum(scoreTable)

    kB = (S ./ minimum(S)) .+ (P ./ minimum(P))

    kC =
        ((lambda .* S) .+ ((1 - lambda) .* P)) ./
        ((lambda .* maximum(S)) .+ ((1 - lambda) * maximum(P)))

    scores = (kA .+ kB .+ kC) ./ 3 .+ (kA .* kB .* kC) .^ (1 / 3)

    rankings = sortperm(scores)

    bestIndex = rankings |> last

    result = CoCoSoResult(decisionMat, w, scores, rankings, bestIndex)

    return result
end


"""
        cocoso(setting; lambda)

Apply CoCoSo (Combined Compromise Solution) method for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object 
 - `lambda::Float64`: joint criterion. 0<=lambda<=1, default=0.5.

# Description 
cocoso() applies the CoCoSo method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::CoCoSoResult`: CoCoSoResult object that holds multiple outputs including scores, rankings, and best index.
"""
function cocoso(setting::MCDMSetting; lambda::Float64 = 0.5)::CoCoSoResult
    cocoso(setting.df, setting.weights, setting.fns, lambda = lambda)
end




end # end of module COCOSO
