module VIKOR

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities



struct VikorMethod <: MCDMMethod
    v::Float64
end

VikorMethod()::VikorMethod = VikorMethod(0.5)

struct VikorResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    weightedDecisionMatrix::Matrix
    bestIndex::Int64
    s::Vector
    r::Vector
    scores::Vector
end


function Base.show(io::IO, result::VikorResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end



"""
        vikor(decisionMat, weights, fns; v = 0.5)

Apply VIKOR (VlseKriterijumska Optimizcija I Kaompromisno Resenje in Serbian) method for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of function that are either maximum or minimum.
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


julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum];

julia> result = vikor(Amat, w, fns);

julia> result.scores
4-element Array{Float64,1}:
  0.7489877763052237
  0.7332093914796731
  1.0
  0.0

julia> result.bestIndex
4

```

# References
Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018
"""
function vikor(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    v::Float64 = 0.5,
)::VikorResult where {F<:Function}
    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    # col_max = colmaxs(decisionMat)
    # col_min = colmins(decisionMat)
    col_max = apply_columns(fns, decisionMat)
    col_min = apply_columns(reverseminmax(fns), decisionMat)


    A = similar(decisionMat)

    for i = 1:nalternatives
        for j = 1:ncriteria
            if fns[j] == maximum
                @inbounds A[i, j] =
                    abs((col_max[j] - decisionMat[i, j]) / (col_max[j] - col_min[j]))
            elseif fns[j] == minimum
                @inbounds A[i, j] =
                    abs((decisionMat[i, j] - col_min[j]) / (col_max[j] - col_min[j]))
            else
                @warn fns[j]
                error("Function must be either maximum or minimum.")
            end
        end
    end

    # weightedA = w * A
    weightedA = Utilities.weightise(A, w)

    s = Vector{Any}(undef, nalternatives)
    r = similar(s)
    q = similar(s)

    for i = 1:nalternatives
        s[i] = sum(weightedA[i, :])
        r[i] = maximum(weightedA[i, :])
    end

    smin = minimum(s)
    smax = maximum(s)
    rmin = minimum(r)
    rmax = maximum(r)
    q =
        v .* (((s .- smin) ./ (smax .- smin))) +
        (1 - v) .* (((r .- rmin) ./ (rmax .- rmin)))


    scores = q

    # select the one with minimum score
    best_index = sortperm(q) |> first

    result = VikorResult(decisionMat, w, weightedA, best_index, s, r, scores)
    return result
end

"""
        vikor(setting; v = 0.5)

Apply VIKOR (VlseKriterijumska Optimizcija I Kaompromisno Resenje in Serbian) method for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 - `v::Float64`: Optional algorithm parameter. Default is 0.5.

# Description 
vikor() applies the VIKOR method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::VikorResult`: VikorResult object that holds multiple outputs including scores and best index.
"""
function vikor(setting::MCDMSetting; v::Float64 = 0.5)::VikorResult
    vikor(setting.df, setting.weights, setting.fns, v = v)
end





end # end module VIKOR 
