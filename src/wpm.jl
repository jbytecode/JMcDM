"""
        wpm(decisionMat, weights, fns)

Apply WPM (Weighted Product Method) for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alterntives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
wpm() applies the WPM method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::WPMResult`: WPMResult object that holds multiple outputs including scores, rankings, and best index.

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

julia> result = wpm(df, weights, fns);

julia> result.scores
5-element Array{Float64,1}:
 0.7975224331331252
 0.7532541470584717
 0.7647463553356331
 0.7873956894790834
 0.7674278741781709

julia> result.bestIndex
1
```

# References
Zavadskas, E. K., Turskis, Z., Antucheviciene, J., & Zakarevicius, A. (2012). Optimization of Weighted Aggregated Sum Product Assessment. Elektronika Ir Elektrotechnika, 122(6), 3-6. https://doi.org/10.5755/j01.eee.122.6.1810
"""
function wpm(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::WPMResult
   
    row, col = size(decisionMat)
    normalizedDecisionMat = similar(decisionMat)
    w = unitize(weights)
    colminmax = zeros(Float64, col)
    @inbounds for i in 1:col
        colminmax[i] = decisionMat[:, i] |> fns[i]
        if fns[i] == maximum
            normalizedDecisionMat[:, i] = decisionMat[:, i] ./ colminmax[i] 
        elseif fns[i] == minimum 
            normalizedDecisionMat[:, i] = colminmax[i] ./ decisionMat[:, i]
        end
    end    
    scoreMat = similar(normalizedDecisionMat)
    for i in 1:col
        scoreMat[:, i] = normalizedDecisionMat[:, i].^w[i]
    end

    scores = zeros(Float64, row)
    for i in 1:row
        scores[i] = prod(scoreMat[i, :])
    end
    rankings = sortperm(scores)
    
    bestIndex = rankings |> last
    
    result = WPMResult(
        decisionMat,
        normalizedDecisionMat,
        w,
        scores,
        rankings,
        bestIndex
    )

    return result
end


function wpm(setting::MCDMSetting)::WPMResult
    wpm(
        setting.df,
        setting.weights,
        setting.fns
    )
end 