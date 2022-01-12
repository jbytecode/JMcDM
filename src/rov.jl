"""
        rov(decisionMat, weights, fns)

Apply ROV (Range of Value) for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns (directions of optimization). 

# Description 
rov() applies the ROV method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::ROVResult`: ROVResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> mat = [
        0.035 34.5 847 1.76 0.335 0.5 0.59 0.59
        0.027 36.8 834 1.68 0.335 0.665 0.665 0.665
        0.037 38.6 808 2.4 0.59 0.59 0.41 0.5
        0.028 32.6 821 1.59 0.5 0.59 0.59 0.41];

julia> df = JMcDM.makeDecisionMatrix(mat)
4×8 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     Crt5     Crt6     Crt7     Crt8    
     │ Float64  Float64  Float64  Float64  Float64  Float64  Float64  Float64 
─────┼────────────────────────────────────────────────────────────────────────
   1 │   0.035     34.5    847.0     1.76    0.335    0.5      0.59     0.59
   2 │   0.027     36.8    834.0     1.68    0.335    0.665    0.665    0.665
   3 │   0.037     38.6    808.0     2.4     0.59     0.59     0.41     0.5
   4 │   0.028     32.6    821.0     1.59    0.5      0.59     0.59     0.41

julia>  w = [0.3306, 0.0718, 0.1808, 0.0718, 0.0459, 0.126, 0.126, 0.0472];

julia> fns = [minimum, minimum, minimum, minimum, maximum, minimum, minimum, maximum]

julia> result = rov(df, w, fns)

julia> result.ranks 

julia> result.scores
```

# References
Madić, Miloš et al. “Application of the ROV method for the selection of cutting fluids.” 
Decision Science Letters 5 (2016): 245-254.
"""
function rov(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})
    n, p = size(decisionMat)

    decmat = Matrix(decisionMat)
    normalizedMat = similar(decmat)

    cmins = colmins(decisionMat)
    cmaxs = colmaxs(decisionMat)

    for j = 1:p
        if fns[j] == maximum
            normalizedMat[:, j] .= (decmat[:, j] .- cmins[j]) ./ (cmaxs[j] - cmins[j])
        elseif fns[j] == minimum
            normalizedMat[:, j] .= (cmaxs[j] .- decmat[:, j]) ./ (cmaxs[j] - cmins[j])
        else
            @warn fns[j]
            error("Function must be either maximum or minimum.")
        end
    end

    uplus = Array{Float64,1}(undef, n)
    uminus = Array{Float64,1}(undef, n)
    u = Array{Float64,1}(undef, n)

    maxindices = filter(x -> fns[x] == maximum, 1:p)
    minindices = filter(x -> fns[x] == minimum, 1:p)

    if length(maxindices) > 0
        for i = 1:n
            uplus[i] = sum(normalizedMat[i, maxindices] .* weights[maxindices])
        end
    end

    if length(minindices) > 0
        for i = 1:n
            uminus[i] = sum(normalizedMat[i, minindices] .* weights[minindices])
        end
    end

    u .= (uminus .+ uplus) ./ 2.0

    ranks = u |> reverse |> sortperm 

    return ROVResult(
        uminus, 
        uplus,
        u,
        ranks
    )
end



function rov(setting::MCDMSetting)::ROVResult
    mairca(
        setting.df,
        setting.weights,
        setting.fns
    )
end 