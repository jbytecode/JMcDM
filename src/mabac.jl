"""
        mabac(decisionMat, weights, fns)

Apply MABAC (Multi-Attributive Border Approximation area Comparison) for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
mabac() applies the MABAC method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MABACResult`: MABACResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [2 1 4 7 6 6 7 3000;
       4 1 5 6 7 7 6 3500;
       3 2 6 6 5 6 8 4000;
       5 1 5 7 6 7 7 3000;
       4 2 5 6 7 7 6 3000;
       3 2 6 6 6 6 6 3500]
6×8 
Array{Int64,2}:
 2  1  4  7  6  6  7  3000
 4  1  5  6  7  7  6  3500
 3  2  6  6  5  6  8  4000
 5  1  5  7  6  7  7  3000
 4  2  5  6  7  7  6  3000
 3  2  6  6  6  6  6  3500

julia> df = makeDecisionMatrix(decmat)
6×8 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     Crt5     Crt6     Crt7     Crt8    
     │ Float64  Float64  Float64  Float64  Float64  Float64  Float64  Float64 
─────┼────────────────────────────────────────────────────────────────────────
   1 │     2.0      1.0      4.0      7.0      6.0      6.0      7.0   3000.0
   2 │     4.0      1.0      5.0      6.0      7.0      7.0      6.0   3500.0
   3 │     3.0      2.0      6.0      6.0      5.0      6.0      8.0   4000.0
   4 │     5.0      1.0      5.0      7.0      6.0      7.0      7.0   3000.0
   5 │     4.0      2.0      5.0      6.0      7.0      7.0      6.0   3000.0
   6 │     3.0      2.0      6.0      6.0      6.0      6.0      6.0   3500.0

julia> weights = [0.293, 0.427, 0.067, 0.027, 0.053, 0.027, 0.053, 0.053];

julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum];

julia> result = mabac(df, weights, fns);

julia> result.scores
6-element Array{Float64,1}:
 -0.3113160790692055
 -0.10898274573587217
  0.2003505875974611
  0.0421839209307945
  0.3445172542641278
  0.2003505875974611

julia> result.bestIndex
5
```

# References

Pamučar, D., & Ćirović, G. (2015). The selection of transport and handling resources in logistics centers using Multi-Attributive Border Approximation area Comparison (MABAC). Expert Systems with Applications, 42(6), 3016–3028. doi:10.1016/j.eswa.2014.11.057

Ulutaş, A. (2019). Entropi ve MABAC yöntemleri ile personel seçimi. OPUS–International Journal of Society Researches, 13(19), 1552-1573. DOI: 10.26466/opus.580456
"""
function mabac(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::MABACResult

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
                @inbounds A[i, j] = (decisionMat[i, j] - colMax[j]) / (colMin[j] - colMax[j])
            end                    
        end
    end

    wA = w * (A .+ 1)

    g = zeros(Float64, col)

    for i in 1:col
        g[i] = geomean(wA[:, i])
    end

    Q = wA .- g'

    scores = zeros(Float64, row)
    for i in 1:row
        scores[i] = sum(Q[i, :])
    end 

    rankings = sortperm(scores)
    
    bestIndex = rankings |> last
    
    result = MABACResult(
        decisionMat,
        w,
        scores,
        rankings,
        bestIndex
    )

    return result
end


function mabac(setting::MCDMSetting)::MABACResult
    mabac(
        setting.df,
        setting.weights,
        setting.fns
    )
end 