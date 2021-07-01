"""
        cocoso(decisionMat, weights, fns, lambda)

Apply CoCoSo (Combined Compromise Solution) method for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns.
 - `lambda::Float64`: joint criterion. 0<=lambda<=1, default=0.5.

# Description 
cocoso() applies the CoCoSo method to rank n alterntives subject to m criteria which are supposed to be 
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

julia> df = makeDecisionMatrix(decmat)
5×6 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     Crt5     Crt6    
     │ Float64  Float64  Float64  Float64  Float64  Float64 
─────┼──────────────────────────────────────────────────────
   1 │     3.0     12.5      2.0    120.0     14.0      3.0
   2 │     5.0     15.0      3.0    110.0     38.0      4.0
   3 │     3.0     13.0      2.0    120.0     19.0      3.0
   4 │     4.0     14.0      2.0    100.0     31.0      4.0
   5 │     3.0     15.0      1.5    125.0     40.0      4.0

julia> weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201];

julia> fns = [maximum, minimum, minimum, maximum, minimum, maximum];

julia> lambda = 0.5;

julia> result = cocoso(df, weights, fns, lambda);

julia> result.scores
7-element Array{Float64,1}:
 2.0413128390265998
 2.787989783418825
 2.8823497955972495
 2.4160457689259287
 1.2986918936013303
 1.4431429073391682
 2.519094173200623

julia> result.bestIndex
3
```
# References

Yazdani, M., Zarate, P., Kazimieras Zavadskas, E. and Turskis, Z. (2019), "A combined compromise solution (CoCoSo) method for multi-criteria decision-making problems", Management Decision, Vol. 57 No. 9, pp. 2501-2519. https://doi.org/10.1108/MD-05-2017-0458

"""
function cocoso(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1}; lambda::Float64=0.5)::CoCoSoResult
   
    row, col = size(decisionMat)
    w = unitize(weights)
    colMax = colmaxs(decisionMat)
    colMin = colmins(decisionMat)

    A = similar(decisionMat)

    for i in 1:row
        for j in 1:col
            if fns[j] == maximum
                @inbounds A[i, j] = (decisionMat[i, j] - colMin[j]) / (colMax[j] - colMin[j])
            elseif fns[j] == minimum
                @inbounds A[i, j] = (colMax[j] - decisionMat[i, j]) / (colMax[j] - colMin[j])
            end                    
        end
    end

    scoreMat = similar(A)
    for i in 1:col
        scoreMat[:, i] = A[:, i].^w[i]
    end

    P = zeros(Float64, row)
    for i in 1:row
        P[i] = sum(scoreMat[i, :])
    end

    S = w * A |> rowsums
    
    scoreTable = [S P]

    kA = (S .+ P) ./ sum(scoreTable)

    kB = (S ./ minimum(S)) .+ (P ./ minimum(P))

    kC = ((lambda .* S) .+ ((1-lambda) .* P)) ./ ((lambda .* maximum(S)) .+ ((1-lambda) * maximum(P)))

    scores = (kA .+ kB .+ kC) ./ 3 .+ (kA .* kB .* kC) .^ (1/3)

    rankings = sortperm(scores)
    
    bestIndex = rankings |> last
    
    result = CoCoSoResult(
        decisionMat,
        w,
        scores,
        rankings,
        bestIndex
    )

    return result
end



function cocoso(setting::MCDMSetting; lambda::Float64=0.5)::CoCoSoResult
    cocoso(
        setting.df,
        setting.weights,
        setting.fns,
        lambda = lambda
    )
end
