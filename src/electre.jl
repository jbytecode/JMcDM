module ELECTRE

export electre, ElectreMethod, ElectreResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities



struct ElectreResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    weightedDecisionMatrix::Matrix
    fitnessTable::Array{Dict,1}
    nonfitnessTable::Array{Dict,1}
    fitnessMatrix::Matrix
    nonfitnessMatrix::Matrix
    C::Vector
    D::Vector
    bestIndex::Tuple
end

struct ElectreMethod <: MCDMMethod end

function Base.show(io::IO, result::ElectreResult)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

"""
        electre(decisionMat, weights, fns)

Apply ELECTRE (ELimination Et Choice Translating REality) method 
for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of function that are either minimize or maximize.

# Description 
electre() applies the ELECTRE method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.
C and D values are used to determine the best strategy. If the strategy with the highest C value 
is same as the strategy with the lowest D value than the solution is unique. Otherwise, two strategies 
are reported as the solution. 

# Output 
- `::ElectreResult`: ElectreResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077];
julia> Amat = [
      100 92 10 2 80 70 95 80 ;
      80  70 8  4 100 80 80 90 ;
      90 85 5 0 75 95 70 70 ; 
      70 88 20 18 60 90 95 85
    ];

julia> fns = [maximum for i in 1:8];
julia> result = electre(Amat, w, fns)


julia> result.bestIndex
(4,)

julia> result.C
4-element Array{Float64,1}:
  0.3693693693693696
  0.01501501501501501
 -2.473473473473473
  2.0890890890890894

julia> result.D
4-element Array{Float64,1}:
  0.1914244325928971
 -0.19039293350192432
  2.884307608766315
 -2.885339107857288
```

# References
Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018
"""
function electre(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1},
)::ElectreResult where {F<:Function}

    w = unitize(weights)

    zerotype = eltype(decisionMat)

    nalternatives, ncriteria = size(decisionMat)

    normalizedMat = normalize(decisionMat)
    
    #weightednormalizedMat = w * normalizedMat
    weightednormalizedMat = Utilities.weightise(normalizedMat, w)

    fitnessTable = []
    nonfitnessTable = []

    for i = 1:nalternatives
        for j = 1:nalternatives
            if i != j
                betterlist = []
                worselist = []
                for h = 1:ncriteria
                    if fns[h] == maximum
                        if weightednormalizedMat[i, h] >= weightednormalizedMat[j, h]
                            push!(betterlist, h)
                        else
                            push!(worselist, h)
                        end
                    else
                        if weightednormalizedMat[i, h] <= weightednormalizedMat[j, h]
                            push!(betterlist, h)
                        else
                            push!(worselist, h)
                        end
                    end
                end
                fitnesstableelement = Dict(:i => i, :j => j, :set => betterlist)
                push!(fitnessTable, fitnesstableelement)

                nonfitnesstableelement = Dict(:i => i, :j => j, :set => worselist)
                push!(nonfitnessTable, nonfitnesstableelement)
            end
        end
    end

    fitnessmatrix = zeros(zerotype, nalternatives, nalternatives)
    nonfitnessmatrix = zeros(zerotype, nalternatives, nalternatives)

    for elements in fitnessTable
        i = elements[:i]
        j = elements[:j]
        elemlist = elements[:set]

        CC = sum(w[elemlist])
        fitnessmatrix[i, j] = CC
    end

    nonfitnessmatrix = zeros(zerotype, nalternatives, nalternatives)
    for elements in nonfitnessTable
        i = elements[:i]
        j = elements[:j]
        elemlist = elements[:set]

        r_ik = weightednormalizedMat[i, elemlist]
        r_jk = weightednormalizedMat[j, elemlist]
        r_ik_full = weightednormalizedMat[i, :]
        r_jk_full = weightednormalizedMat[j, :]

        if length(r_ik) > 0 && length(r_jk) > 0
            nom = maximum(abs.(r_ik - r_jk))
            dom = maximum(abs.(r_ik_full - r_jk_full))
            nonfitnessmatrix[i, j] = nom / dom
        else
            nonfitnessmatrix[i, j] = Inf64
        end  # end if 

    end # end for 

    C = zeros(zerotype, nalternatives)
    D = zeros(zerotype, nalternatives)
    for i = 1:nalternatives
        C[i] = sum(fitnessmatrix[i, :]) - sum(fitnessmatrix[:, i])
        D[i] = sum(nonfitnessmatrix[i, :]) - sum(nonfitnessmatrix[:, i])
    end

    best_C_index = sortperm(C) |> last
    best_D_index = sortperm(D) |> first
    best = nothing

    if best_C_index == best_D_index
        best = (best_C_index,)
    else
        best = (best_C_index, best_D_index)
    end

    result = ElectreResult(
        decisionMat,
        w,
        weightednormalizedMat,
        fitnessTable,
        nonfitnessTable,
        fitnessmatrix,
        nonfitnessmatrix,
        C,
        D,
        best,
    )

    return result
end



"""
        electre(setting)

Apply ELECTRE (ELimination Et Choice Translating REality) method 
for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
electre() applies the ELECTRE method to rank n strategies subject to m criteria which are supposed to be either maximized or minimized.
C and D values are used to determine the best strategy. If the strategy with the highest C value 
is same as the strategy with the lowest D value than the solution is unique. Otherwise, two strategies 
are reported as the solution. 

# Output 
- `::ElectreResult`: ElectreResult object that holds multiple outputs including scores and best index.
"""
function electre(setting::MCDMSetting)::ElectreResult
    electre(setting.df, setting.weights, setting.fns)
end



end # end of module ELECTRE 
