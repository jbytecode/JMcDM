module ARAS


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

import ..Utilities: weightise

using ..Utilities



struct ArasMethod <: MCDMMethod 
    normalization::G where {G<: Function}
end

ArasMethod() = ArasMethod(Normalizations.dividebycolumnsumnormalization)

struct ARASResult <: MCDMResult
    referenceRow::Vector
    extendMat::Matrix
    normalizedMat::Matrix
    weightedNormalizedMat::Matrix
    optimalitydegrees::Vector
    scores::Vector
    orderings::Array{Int64,1}
    bestIndex::Int64
end


"""
    aras(decisionMat, weights, fs; normalization)
Apply ARAS (Additive Ratio ASsessment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fs::Array{<:Function,1}`: m-vector of type of criteria. The benefit criteria shown with "maximum", and the cost criteria shown with "minimum".
 - `normalization{<:Function}`: Optional normalization function.

 # Description 
aras() applies the ARAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::ARASResult`: ARASResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> df = DataFrame(
    :K1 => [105000.0, 120000, 150000, 115000, 135000],
    :K2 => [105.0, 110, 120, 105, 115],
    :K3 => [10.0, 15, 12, 20, 15],
    :K4 => [4.0, 4, 3, 4, 5],
    :K5 => [300.0, 500, 550, 600, 400],
    :K6 => [10.0, 8, 12, 9, 9]
)
julia> df
5×6 DataFrame
 Row │ K1        K2       K3       K4       K5       K6      
     │ Float64   Float64  Float64  Float64  Float64  Float64 
─────┼───────────────────────────────────────────────────────
   1 │ 105000.0    105.0     10.0      4.0    300.0     10.0
   2 │ 120000.0    110.0     15.0      4.0    500.0      8.0
   3 │ 150000.0    120.0     12.0      3.0    550.0     12.0
   4 │ 115000.0    105.0     20.0      4.0    600.0      9.0
   5 │ 135000.0    115.0     15.0      5.0    400.0      9.0

julia> result = aras(Matrix(df), w, fs);
julia> result.bestIndex
2
julia> result.scores
5-element Array{Float64,1}:
 0.8142406768388222
 0.8928861957614441
 0.764157900073527
 0.8422546181927358
 0.8654063509472654
```
# References
Zavadskas, E. K., & Turskis, Z. (2010). A new additive ratio assessment (ARAS) method in multicriteria decision‐making. Technological and Economic Development of Economy, 16(2), 159-172.
Yıldırım, B. F. (2015). "Çok Kriterli Karar Verme Problemlerinde ARAS Yöntemi". Kafkas Üniversitesi İktisadi ve İdari Bilimler Fakültesi Dergisi, 6 (9), 285-296. http://dx.doi.org/10.18025/kauiibf.65151
"""
function aras(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fs::Array{F,1}; 
    normalization::G = Normalizations.dividebycolumnsumnormalization 
)::ARASResult where {F<:Function, G<: Function}

    nrows, ncols = size(decisionMat)
    w = unitize(weights)

    referenceRow = apply_columns(fs, decisionMat)
    extendMat = [decisionMat; referenceRow']

    for col = 1:ncols
        if fs[col] == minimum
            extendMat[:, col] = 1 ./ extendMat[:, col]
        end
    end

    normalizedMat = normalization(extendMat, fs)
    # Even not necessary, we provide the weighted normalized matrix
    # Weightization is done by optimality degrees
    weightednormalizedmatrix = weightise(normalizedMat, w)
    

    optimality_degrees = Vector(undef, nrows + 1)
    for i = 1:nrows+1
        optimality_degrees[i] = w .* normalizedMat[i, :] |> sum
    end

    utility_degrees = Vector(undef, nrows)
    for i = 1:nrows
        utility_degrees[i] = optimality_degrees[i] / optimality_degrees[end]
    end

    orderings = sortperm(utility_degrees)
    bestIndex = orderings |> last

    result = ARASResult(
        referenceRow,
        extendMat,
        normalizedMat,
        weightednormalizedmatrix,
        optimality_degrees,
        utility_degrees,
        orderings,
        bestIndex,
    )

    return result
end

"""
    aras(setting)
Apply ARAS (Additive Ratio ASsessment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
 # Description 
aras() applies the ARAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::ARASResult`: ARASResult object that holds multiple outputs including scores and best index.
"""
function aras(setting::MCDMSetting)::ARASResult
    aras(setting.df, setting.weights, setting.fns)
end


end # end of module ARAS
