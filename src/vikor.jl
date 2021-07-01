"""
        vikor(decisionMat, weights, fns; v = 0.5)

Apply VIKOR (VlseKriterijumska Optimizcija I Kaompromisno Resenje in Serbian) method for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of function that are either maximum or minimum.
 - `v::Float64`: Optional algorithm parameter. Default is 0.5.

# Description 
vikor() applies the VIKOR method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::VikorResult`: VikorResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
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

julia> result = vikor(dmat, w, fns);

julia> result.scores
4-element Array{Float64,1}:
  0.1975012087551764
  0.2194064473270817
  0.3507643203516215
 -0.16727341435277993

julia> result.bestIndex
4

```

# References
Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018
"""
function vikor(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1}; v::Float64=0.5)::VikorResult
    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    # col_max = colmaxs(decisionMat)
    # col_min = colmins(decisionMat)
    col_max = apply_columns(fns, decisionMat)
    col_min = apply_columns(reverseminmax(fns), decisionMat)

    A = similar(decisionMat)

    for i in 1:nalternatives
        for j in 1:ncriteria
            if fns[j] == maximum
                @inbounds A[i, j] = abs((col_max[j] - decisionMat[i, j]) / (col_max[j] - col_min[j]))
            elseif fns[j] == minimum 
                @inbounds A[i, j] = abs((decisionMat[i, j] - col_min[j]) / (col_max[j] - col_min[j]))
            else
                @warn fns[j]
                error("Function must be either maximum or minimum.")
            end    
        end
    end

    weightedA = w * A

    s = Array{Float64,1}(undef, nalternatives)
    r = similar(s)
    q = similar(s)

    for i in 1:nalternatives
        s[i] = sum(weightedA[i,:])
        r[i] = maximum(weightedA[i,:])
    end

    smin = minimum(s)
    smax = maximum(s)
    rmin = minimum(r)
    rmax = maximum(r)
    q = v .* ((s .- smin ./ (smax .- smin))) + (1 - v) .* ((r .- rmin ./ (rmax .- rmin)))

    scores = q

    # select the one with minimum score
    best_index = sortperm(q) |> first 

    result = VikorResult(
        decisionMat,
        w,
        weightedA,
        best_index,
        scores
    )
    return result
end


function vikor(setting::MCDMSetting; v::Float64=0.5)::VikorResult
    vikor(
        setting.df,
        setting.weights,
        setting.fns,
        v = v
    )
end 