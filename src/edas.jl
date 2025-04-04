module EDAS

export edas, EdasMethod, EDASResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting

import ..Utilities: weightise

using ..Utilities



struct EdasMethod <: MCDMMethod end

struct EDASResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    NDAMatrix::Matrix 
    PDAMatrix::Matrix
    weightedNDAMatrix::Matrix
    weightedPDAMatrix::Matrix
    SN::Vector 
    SP::Vector
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end


"""
        edas(decisionMat, weights, fns)

Apply EDAS (Evaluation based on Distance from Average Solution) for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alterntives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
edas() applies the EDAS method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::EDASResult`: EDASResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [5000 5 5300 450;
       4500 5 5000 400;
       4500 4 4700 400;
       4000 4 4200 400;
       5000 4 7100 500;
       5000 5 5400 450;
       5500 5 6200 500;
       5000 4 5800 450]
8×4 Array{Int64,2}:
 5000  5  5300  450
 4500  5  5000  400
 4500  4  4700  400
 4000  4  4200  400
 5000  4  7100  500
 5000  5  5400  450
 5500  5  6200  500
 5000  4  5800  450


julia> weights = [0.25, 0.25, 0.25, 0.25];

julia> fns = [maximum, maximum, minimum, minimum];

julia> result = edas(decmat, weights, fns);

julia> result.scores
8-element Array{Float64,1}:
 0.7595941163602383
 0.8860162461306114
 0.6974721951442592
 0.739657763190231
 0.05908329207449442
 0.7318326305342363
 0.6416913873322523
 0.38519414045559647

julia> result.bestIndex
2
```

# References

Keshavarz Ghorabaee, M., Zavadskas, E. K., Olfat, L., & Turskis, Z. (2015). Multi-criteria inventory classification using a new method of evaluation based on distance from average solution (EDAS). Informatica, 26(3), 435-451.

Ulutaş, A. (2017). EDAS Yöntemi Kullanılarak Bir Tekstil Atölyesi İçin Dikiş Makinesi Seçimi. İşletme Araştırmaları Dergisi, 9(2), 169-183.

"""
function edas(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1},
)::EDASResult where {F<:Function}

    row, col = size(decisionMat)

    w = unitize(weights)


    PDAMatrix = similar(decisionMat)
    NDAMatrix = similar(decisionMat)

    AV = zeros(eltype(decisionMat), col)

    @inbounds for i = 1:col
        AV[i] = mean(decisionMat[:, i])
        for j = 1:row
            if fns[i] == maximum
                PDAMatrix[j, i] = max(zero(eltype(decisionMat)), decisionMat[j, i] - AV[i]) / AV[i]
                NDAMatrix[j, i] = max(zero(eltype(decisionMat)), AV[i] - decisionMat[j, i]) / AV[i]
            elseif fns[i] == minimum
                PDAMatrix[j, i] = max(zero(eltype(decisionMat)), AV[i] - decisionMat[j, i]) / AV[i]
                NDAMatrix[j, i] = max(zero(eltype(decisionMat)), decisionMat[j, i] - AV[i]) / AV[i]
            end
        end
    end

    weightedPDAMatrix = weightise(PDAMatrix, w)
    weightedNDAMatrix = weightise(NDAMatrix, w)


    SP = zeros(eltype(decisionMat), row)
    SN = zeros(eltype(decisionMat), row)

    for i = 1:row
        SP[i] = w .* PDAMatrix[i, :] |> sum
        SN[i] = w .* NDAMatrix[i, :] |> sum
    end

    NSP = SP ./ maximum(SP)
    NSN = 1 .- SN ./ maximum(SN)

    scores = (NSP .+ NSN) ./ 2

    rankings = sortperm(scores)

    bestIndex = rankings |> last

    result = EDASResult(
        decisionMat, 
        w,
        NDAMatrix,
        PDAMatrix,
        weightedNDAMatrix,
        weightedPDAMatrix,
        SN,
        SP, 
        scores, 
        rankings, 
        bestIndex)

    return result
end


"""
        edas(setting)

Apply EDAS (Evaluation based on Distance from Average Solution) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
edas() applies the EDAS method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::EDASResult`: EDASResult object that holds multiple outputs including scores, rankings, and best index.
"""
function edas(setting::MCDMSetting)::EDASResult
    edas(setting.df, setting.weights, setting.fns)
end




end # end of module EDAS 
