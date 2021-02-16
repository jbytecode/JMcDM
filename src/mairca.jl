"""
        mairca(decisionMat, weights, fns)

Apply MAIRCA (Multi Attributive Ideal-Real Comparative Analysis) for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
mairca() applies the MAIRCA method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MAIRCAResult`: MAIRCAResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [6.952 8.000 6.649 7.268 8.000 7.652 6.316;
       7.319 7.319 6.604 7.319 8.000 7.652 5.313;
       7.000 7.319 7.652 6.952 7.652 6.952 4.642;
       7.319 6.952 6.649 7.319 7.652 6.649 5.000]
4×7 Array{Float64,2}:
 6.952  8.0    6.649  7.268  8.0    7.652  6.316
 7.319  7.319  6.604  7.319  8.0    7.652  5.313
 7.0    7.319  7.652  6.952  7.652  6.952  4.642
 7.319  6.952  6.649  7.319  7.652  6.649  5.0

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

julia> weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140];

julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum];

julia> result = mairca(df, weights, fns);

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

Pamučar, D., Lukovac, V., Božanić, D., & Komazec, N. (2018). Multi-criteria FUCOM-MAIRCA model for the evaluation of level crossings: case study in the Republic of Serbia. Operational Research in Engineering Sciences: Theory and Applications, 1(1), 108-129.

Ulutaş A.(2019),Swara Ve Mairca Yöntemleri İle Catering Firması Seçimi,BMIJ, (2019), 7(4): 1467-1479 http://dx.doi.org/10.15295/bmij.v7i4.1166
"""
function mairca(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::MAIRCAResult

    row, col = size(decisionMat)

    w = unitize(weights)

    colMax = colmaxs(decisionMat)
    colMin = colmins(decisionMat)

    A = copy(decisionMat)

    for i in 1:row
        for j in 1:col
            if fns[j] == maximum
                @inbounds A[i, j] = (A[i, j] - colMin[j]) / (colMax[j] - colMin[j])
            elseif fns[j] == minimum
                @inbounds A[i, j] = (A[i, j] - colMax[j]) / (colMin[j] - colMax[j])
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
    
    result = MAIRCAResult(
        decisionMat,
        w,
        scores,
        rankings,
        bestIndex
    )

    return result
end
