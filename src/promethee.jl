"""
    Linear preference function for PROMETHEE.

"""
function prometLinear(d::Number, q::Number, p::Number)::Float64
    if (d <= q)
        0
    elseif (q < d <= p)
        (d - q) / (p - q)
    else
        1
    end
end

"""
    V-shaped preference function for PROMETHEE.
        
"""
function prometVShape(d::Number, q::Any, p::Number)::Float64
    if (d <= 0)
        0
    elseif (0 < d <= p)
        d / p
    else
        1
    end
end

"""
    U-Shaped preference function for PROMETHEE.
        
"""
function prometUShape(d::Number, q::Any, p::Any)::Float64
    if (d == 0)
        0
    else
        1
    end
end

"""
    Quasi preference function for PROMETHEE.
        
"""
function prometQuasi(d::Number, q::Number, p::Any)::Float64
    if (d <= q)
        0
    else
        1
    end
end

"""
    Level preference function for PROMETHEE.
        
"""
function prometLevel(d::Number, q::Number, p::Number)::Float64
    if (d <= q)
        0
    elseif (0 < d <= p)
        1 / 2
    else
       1
    end
end

"""
        promethee(decisionMatrix, weights, fns, prefs, qs, ps)

Apply PROMETHEE (Preference Ranking Organization METHod for Enrichment of Evaluations) method for a given matrix and weights.

# Arguments:
 - `decisionMatrix::DataFrame`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions that are either maximum or minimum.
 - `pref::Array{Function, 1}`: m-vector of preference functions that are prometLinear, prometVShape, prometUShape, prometQuasi, or prometLevel.
 - `qs::Array{Float64, 1}`: m-vector of q parameters that is used in corresponding preference function.
 - `ps::Array{Float64, 1}`: m-vector of p parameters that is used in corresponding preference function
 
# Description 
promethee() applies the PROMETHEE method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::Result`: PrometheeResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> decmat = [42.0 35 43 51; 
                     89 72 92 85;
                     14 85 17 40;
                     57 60 45 80;
                     48 32 43 40;
                     71 45 60 85;
                     69 40 72 55;
                     64 35 70 60];

julia> df = makeDecisionMatrix(decmat)
8×4 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4    
     │ Float64  Float64  Float64  Float64 
─────┼────────────────────────────────────
   1 │    42.0     35.0     43.0     51.0
   2 │    89.0     72.0     92.0     85.0
   3 │    14.0     85.0     17.0     40.0
   4 │    57.0     60.0     45.0     80.0
   5 │    48.0     32.0     43.0     40.0
   6 │    71.0     45.0     60.0     85.0
   7 │    69.0     40.0     72.0     55.0
   8 │    64.0     35.0     70.0     60.0

julia> qs = [49, nothing, 45, 30];

julia> ps = [100, 98, 95, 80];

julia> weights = [0.25, 0.35, 0.22, 0.18];

julia> fns = makeminmax([maximum, maximum, maximum, maximum]);

julia> prefs = convert(Array{Function,1}, [prometLinear, prometVShape, prometLinear, prometLinear]);

julia> result = promethee(df, weights, fns, prefs, qs, ps);

julia> result.scores
8-element Array{Float64,1}:
  0.0698938775510204
 -0.148590956382553
 -0.061361984793917565
 -0.04780408163265306
  0.09859591836734694
 -0.0006389755902360891
  0.03236974789915966
  0.057536454581832736

julia> result.bestIndex
5
```

# References
İşletmeciler, Mühendisler ve Yöneticiler için Operasyonel, Yönetsel ve Stratejik Problemlerin
Çözümünde Çok Kriterli Karar verme Yöntemleri, Editörler: Bahadır Fatih Yıldırım ve Emrah Önder,
Dora, 2. Basım, 2015, ISBN: 978-605-9929-44-8
"""
function promethee(
    decisionMatrix::DataFrame, 
    weights::Array{Float64,1}, 
    fns::Array{Function,1}, 
    prefs::Array{Function,1}, 
    qs::Array, 
    ps::Array)::PrometheeResult

    actionCount, criteriaCount = size(decisionMatrix)

    dValues = zeros(Float64, criteriaCount, actionCount, actionCount)

    for c in 1:criteriaCount, i in 1:actionCount, j in 1:actionCount
        dValues[c,i,j] = fns[c]([-1, 1]) * (decisionMatrix[i,c] - decisionMatrix[j,c])
    end

    pValues = zeros(Float64, criteriaCount, actionCount, actionCount)

    for c in 1:criteriaCount, i in 1:actionCount, j in 1:actionCount
        pValues[c,i,j] = prefs[c](dValues[c,i,j], qs[c], ps[c])
    end

    pValues .*= weights
    
    flows = sum(pValues, dims=1)[1,:,:]

    negSum = sum(flows, dims=1)[1,:] / (actionCount - 1)
    posSum = sum(flows, dims=2)[:,1] / (actionCount - 1)

    scores = negSum - posSum

    rankings = scores |> sortperm
    
    bestIndex = rankings |> last

    return PrometheeResult(
        decisionMatrix, 
        weights, 
        scores, 
        rankings, 
        bestIndex)

end




function promethee(setting::MCDMSetting, prefs::Array{Function,1}, qs::Array, ps::Array)::PrometheeResult
    promethee(
        setting.df,
        setting.weights,
        setting.fns,
        prefs,
        qs,
        ps
    )
end 