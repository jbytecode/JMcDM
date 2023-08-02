module MAIRCA

export mairca, MaircaMethod, MAIRCAResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities



struct MAIRCAResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end


struct MaircaMethod <: MCDMMethod end


"""
        mairca(decisionMat, weights, fns)

Apply MAIRCA (Multi Attributive Ideal-Real Comparative Analysis) for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns. 

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


julia> weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140];

julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum];

julia> result = mairca(decmat, weights, fns);

julia> result.scores
4-element Array{Float64,1}:
 0.12064543054088471
 0.08066456363291889
 0.14586265389012484
 0.14542366685864686

julia> result.bestIndex
2
```

# References

Pamučar, D., Lukovac, V., Božanić, D., & Komazec, N. (2018). Multi-criteria FUCOM-MAIRCA model for the evaluation of level crossings: case study in the Republic of Serbia. Operational Research in Engineering Sciences: Theory and Applications, 1(1), 108-129.

Ulutaş A.(2019),Swara Ve Mairca Yöntemleri İle Catering Firması Seçimi,BMIJ, (2019), 7(4): 1467-1479 http://dx.doi.org/10.15295/bmij.v7i4.1166
"""
function mairca(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.maxminrangenormalization
)::MAIRCAResult where {F<:Function, G<:Function}

    row, col = size(decisionMat)

    w = unitize(weights)

    zerotype = eltype(decisionMat)

    T = zeros(zerotype, row, col)

    for i = 1:col
        T[:, i] .= w[i] * (one(zerotype) / row)
    end

    #A = similar(decisionMat)
    #for i = 1:row
    #    for j = 1:col
    #        if fns[j] == maximum
    #            @inbounds A[i, j] =
    #                T[i, j] * ((decisionMat[i, j] - colMin[j]) / (colMax[j] - colMin[j]))
    #        elseif fns[j] == minimum
    #            @inbounds A[i, j] =
    #                T[i, j] * ((decisionMat[i, j] - colMax[j]) / (colMin[j] - colMax[j]))
    #        end
    #    end
    #end

    A = normalization(decisionMat, fns)
    A = A .* T


    S = T .- A

    scores = zeros(zerotype, row)

    for i = 1:row
        scores[i] = sum(S[i, :])
    end

    rankings = sortperm(scores)

    bestIndex = rankings |> first

    result = MAIRCAResult(decisionMat, w, scores, rankings, bestIndex)

    return result
end



"""
        mairca(setting)

Apply MAIRCA (Multi Attributive Ideal-Real Comparative Analysis) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
mairca() applies the MAIRCA method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MAIRCAResult`: MAIRCAResult object that holds multiple outputs including scores, rankings, and best index.
"""
function mairca(setting::MCDMSetting)::MAIRCAResult
    mairca(setting.df, setting.weights, setting.fns)
end




end # end of module MAIRCA 
