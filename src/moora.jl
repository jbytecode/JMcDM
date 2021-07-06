"""
        moora(decisionMat, weights, fns)

Apply MOORA (Multi-Objective Optimization By Ratio Analysis) method for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of function that are either maximum or minimum.

# Description 
moora() applies the MOORA method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::MooraResult`: MooraResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077];

julia> Amat = [
             100 92 10 2 80 70 95 80 ;
             80  70 8  4 100 80 80 90 ;
             90 85 5 0 75 95 70 70 ; 
             70 88 20 18 60 90 95 85
           ];

julia> dmat = makeDecisionMatrix(Amat)
4×8 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     Crt5     Crt6     Crt7     Crt8    
     │ Float64  Float64  Float64  Float64  Float64  Float64  Float64  Float64 
─────┼────────────────────────────────────────────────────────────────────────
   1 │   100.0     92.0     10.0      2.0     80.0     70.0     95.0     80.0
   2 │    80.0     70.0      8.0      4.0    100.0     80.0     80.0     90.0
   3 │    90.0     85.0      5.0      0.0     75.0     95.0     70.0     70.0
   4 │    70.0     88.0     20.0     18.0     60.0     90.0     95.0     85.0

julia> fns = makeminmax([maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]);

julia> result = moora(dmat, w, fns)

julia> result.scores
4-element Array{Float64,1}:
 0.3315938731541169
 0.2901446390098523
 0.3730431072983815
 0.019265256092245782

julia> result.bestIndex
4
```

# References
Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018

İşletmeciler, Mühendisler ve Yöneticiler için Operasyonel, Yönetsel ve Stratejik Problemlerin
Çözümünde Çok Kriterli Karar verme Yöntemleri, Editörler: Bahadır Fatih Yıldırım ve Emrah Önder,
Dora, 2. Basım, 2015, ISBN: 978-605-9929-44-8
"""
function moora(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::MooraResult

    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    normalizedMat = normalize(decisionMat)
    weightednormalizedMat = w * normalizedMat

    # cmaxs = colmaxs(weightednormalizedMat)
    cmaxs = apply_columns(fns, weightednormalizedMat)
    cmins = apply_columns(reverseminmax(fns), weightednormalizedMat)

    refmat = similar(weightednormalizedMat)
    
    for rowind in 1:nalternatives
        if fns[rowind] == maximum 
            refmat[rowind, :] .= cmaxs - weightednormalizedMat[rowind, :]
        elseif fns[rowind] == minimum
            refmat[rowind, :] .= weightednormalizedMat[rowind, :] - cmins
        else
            @warn fns[rowind]
            error("Function must be either maximize or minimize")
        end
    end

    scores = rmaxs = rowmaxs(refmat)

    bestIndex = sortperm(rmaxs) |> first 

    result = MooraResult(
       decisionMat,
       w,
       weightednormalizedMat,
       refmat,
       scores,
       bestIndex
   )

    return result
end


"""
        moora(setting)

Apply MOORA (Multi-Objective Optimization By Ratio Analysis) method for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
moora() applies the MOORA method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::MooraResult`: MooraResult object that holds multiple outputs including scores and best index.
"""
function moora(setting::MCDMSetting)::MooraResult
    moora(
        setting.df,
        setting.weights,
        setting.fns
    )
end 
