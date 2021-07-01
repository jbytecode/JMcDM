"""
        topsis(decisionMat, weights, fns)

Apply TOPSIS (Technique for Order of Preference by Similarity to Ideal Solution) method 
for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of function that are either minimize or maximize.

# Description 
topsis() applies the TOPSIS method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::TopsisResult`: TopsisResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> df = DataFrame();
julia> df[:, :x] = Float64[9, 8, 7];
julia> df[:, :y] = Float64[7, 7, 8];
julia> df[:, :z] = Float64[6, 9, 6];
julia> df[:, :q] = Float64[7, 6, 6];

julia> w = Float64[4, 2, 6, 8];

julia> df
3×4 DataFrame
 Row │ x        y        z        q       
     │ Float64  Float64  Float64  Float64 
─────┼────────────────────────────────────
   1 │     9.0      7.0      6.0      7.0
   2 │     8.0      7.0      9.0      6.0
   3 │     7.0      8.0      6.0      6.0

julia> fns = makeminmax([maximum, maximum, maximum, maximum]);
julia> result = topsis(df, w, fns);

julia> result.bestIndex
2

julia> result.scores
3-element Array{Float64,1}:
 0.38768695492211824
 0.6503238218850163
 0.08347670030339041
```

# References
Hwang, C.L.; Yoon, K. (1981). Multiple Attribute Decision Making: Methods and Applications. New York: Springer-Verlag

Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018

İşletmeciler, Mühendisler ve Yöneticiler için Operasyonel, Yönetsel ve Stratejik Problemlerin
Çözümünde Çok Kriterli Karar verme Yöntemleri, Editörler: Bahadır Fatih Yıldırım ve Emrah Önder,
Dora, 2. Basım, 2015, ISBN: 978-605-9929-44-8
"""
function topsis(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::TopsisResult

w = unitize(weights)
nalternatives, ncriteria = size(decisionMat)

normalizedMat = normalize(decisionMat)

weightednormalizedMat = w * normalizedMat

    # col_max = colmaxs(weightednormalizedMat)
    # col_min = colmins(weightednormalizedMat)
    col_max = apply_columns(fns, weightednormalizedMat)
    col_min = apply_columns(reverseminmax(fns), weightednormalizedMat)

    distances_plus  = zeros(Float64, nalternatives)
    distances_minus = zeros(Float64, nalternatives)

    scores = zeros(Float64, nalternatives)

    @inbounds for i in 1:nalternatives
        ithrow = weightednormalizedMat[i,:] |> Array{Float64,1}
		distances_plus[i]  = euclidean(col_max, ithrow)
		distances_minus[i] = euclidean(col_min, ithrow)
		scores[i] = distances_minus[i] / (distances_minus[i] + distances_plus[i])
    end
    
    best_index = sortperm(scores) |> last
    
    topsisresult = TopsisResult(
        decisionMat,
        w,
        normalizedMat,
        weightednormalizedMat,
        best_index,
        scores
    ) 

    return topsisresult
end


function topsis(setting::MCDMSetting)::TopsisResult
    topsis(
        setting.df,
        setting.weights,
        setting.fns
    )
end 