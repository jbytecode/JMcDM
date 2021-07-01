"""
        entropy(decisionMat)

Apply Entropy method for a given matrix and criteria types.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 

# Description 
entropy() applies the Entropy method to calculate objective weights which are obtained through multi-step calculations of the decision matrix constructed from the actual information about the evaluation criteria of the alternatives.

# Output 
- `::EntropyResult`: EntropyResult object that holds multiple outputs including weighting and best index.

# Examples
```julia-repl

julia> df = DataFrame(
           C1 = [2, 4, 3, 5, 4, 3],
           C2 = [1, 1, 2, 1, 2, 2],
           C3 = [4, 5, 6, 5, 5, 6],
           C4 = [7, 6, 6, 7, 6, 6],
           C5 = [6, 7, 5, 6, 7, 6],
           C6 = [6, 7, 6, 7, 7, 6],
           C7 = [7, 6, 8, 7, 6, 6],
           C8 = [3000, 3500, 4000, 3000, 3000, 3500]
           )
6×8 DataFrame
 Row │ C1     C2     C3     C4     C5     C6     C7     C8    
     │ Int64  Int64  Int64  Int64  Int64  Int64  Int64  Int64 
─────┼────────────────────────────────────────────────────────
   1 │     2      1      4      7      6      6      7   3000
   2 │     4      1      5      6      7      7      6   3500
   3 │     3      2      6      6      5      6      8   4000
   4 │     5      1      5      7      6      7      7   3000
   5 │     4      2      5      6      7      7      6   3000
   6 │     3      2      6      6      6      6      6   3500

julia> result = entropy(df);

julia> result.w
8-element Array{Float64,1}:
 0.29967360959745126
 0.441367338923551
 0.07009088719659533
 0.021238237112072383
 0.0490229289460051
 0.023080378850660263
 0.0477633096868323
 0.0477633096868323

julia> result.bestIndex
2
```
# References

Shannon, C. E. (1948). A Mathematical Theory of Communication. Bell System Technical Journal, 27(3), 379–423. doi:10.1002/j.1538-7305.1948.tb01338.x
Ulutaş, A . (2019). Entropi ve MABAC Yöntemleri ile Personel Seçimi. OPUS Uluslararası Toplum Araştırmaları Dergisi, 13 (19), 1552-1573. DOI: 10.26466/opus.580456.

"""
function entropy(decisionMat::DataFrame):EntropyResult
    
    row, col = size(decisionMat)
    normalizeDM = zeros(Float64, row, col)

    for i in 1:col
        normalizeDM[:, i] = decisionMat[:,i] ./ sum(decisionMat[:, i])
    end

    logMat = zeros(Float64, row, col)
    for i in 1:row
        for j in 1:col
            logMat[i,j] = normalizeDM[i, j] .* log(normalizeDM[i, j])
        end    
    end

    e = zeros(Float64, col)

    for i in 1:col
        e[i] = 1 - sum(logMat[:,i]) ./ -log(row)
    end

    w = zeros(Float64, col)
    
    for i in 1:col
        w[i] = e[i] ./ sum(e)
    end
    
    rankings = sortperm(w)
    
    bestIndex = rankings |> last
    
    result = EntropyResult(
        decisionMat,
        w,
        rankings,
        bestIndex
    )

    return result
end
