module CODAS

export codas, CodasMethod, CODASResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations 

using ..Utilities



struct CODASResult <: MCDMResult
    decisionMatrix::Matrix
    normalizedDecisionMat::Matrix
    weightedNormalizedDecisionMat::Matrix
    w::Vector{Float64}
    E::Matrix
    Euc::Vector
    T::Matrix
    Tax::Vector
    EA::Matrix
    TA::Matrix
    RA::Matrix
    scores::Vector
    ranking::Vector{Int64}
    bestIndex::Int64
end


struct CodasMethod <: MCDMMethod
    tau::Float64
    normalization::G where {G<:Function}
end

CodasMethod()::CodasMethod = CodasMethod(0.02, Normalizations.dividebycolumnmaxminnormalization)




"""
    codas(decisionMat, weights, fs; normalization)
Apply CODAS (COmbinative Distance-based ASsessment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fs::Array{<:Function,1}`: m-vector of type of criteria. The benefit criteria shown with "maximum", and the cost criteria shown with "minimum".
 - `tau::Float64`: tau parameter for the algorithm. The default is 0.02.
 - `normalization{<:Function}`: Optional normalization function.

 # Description 
codas() applies the CODAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::CODASResult`: CODASResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> decmat
7×5 Array{Float64,2}:
 60.0   0.4   2540.0   500.0   990.0
  6.35  0.15  1016.0  3000.0  1041.0
  6.8   0.1   1727.2  1500.0  1676.0
 10.0   0.2   1000.0  2000.0   965.0
  2.5   0.1    560.0   500.0   915.0
  4.5   0.08  1016.0   350.0   508.0
  3.0   0.1   1778.0  1000.0   920.0

julia> df = DataFrame(decmat)
7×5 DataFrame
 Row │ x1       x2       x3       x4       x5      
     │ Float64  Float64  Float64  Float64  Float64 
─────┼─────────────────────────────────────────────
   1 │   60.0      0.4    2540.0    500.0    990.0
   2 │    6.35     0.15   1016.0   3000.0   1041.0
   3 │    6.8      0.1    1727.2   1500.0   1676.0
   4 │   10.0      0.2    1000.0   2000.0    965.0
   5 │    2.5      0.1     560.0    500.0    915.0
   6 │    4.5      0.08   1016.0    350.0    508.0
   7 │    3.0      0.1    1778.0   1000.0    920.0

julia> result = codas(Matrix(df), w, fs);
julia> result.bestIndex
2
julia> result.scores
7-element Array{Float64,1}:
  0.5121764914884954
  1.463300034504913
  1.0715325899642418
 -0.21246799780012637
 -1.8515205523193041
 -1.1716767695713806
  0.18865620373316055

```
# References
Keshavarz Ghorabaee, M., Zavadskas, E. K., Turskis, Z., & Antucheviciene, J. (2016). A new combinative distance-based assessment (CODAS) method for multi-criteria decision-making. Economic Computation & Economic Cybernetics Studies & Research, 50(3), 25-44.
"""
function codas(
    decisionMat::Matrix,
    weight::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.dividebycolumnmaxminnormalization,
    tau::Float64 = 0.02,
)::CODASResult where {F<:Function, G<:Function}

    nrows, ncols = size(decisionMat)
    w = unitize(weight)

    A = normalization(decisionMat, fns)

    wA = similar(A)

    for i = 1:ncols
        @inbounds wA[:, i] = A[:, i] .* w[i]
    end

    wAmin = colmins(wA)

    E = similar(A)
    for i = 1:nrows
        for j = 1:ncols
            E[i, j] = (wA[i, j] .- wAmin[j])^2
        end
    end

    Euc = Vector{Any}(undef, nrows)
    for i = 1:nrows
        Euc[i] = sqrt(sum(E[i, :]))
    end

    T = similar(A)
    for i = 1:nrows
        for j = 1:ncols
            T[i, j] = abs(wA[i, j] .- wAmin[j])
        end
    end

    Tax = Vector{Any}(undef, nrows)
    for i = 1:nrows
        Tax[i] = sum(T[i, :])
    end

    EA = Matrix{Any}(undef, nrows, nrows)
    TA = Matrix{Any}(undef, nrows, nrows)
    RA = Matrix{Any}(undef, nrows, nrows)

    for i = 1:nrows
        for j = 1:nrows
            EA[i, j] = Euc[i] - Euc[j]
            TA[i, j] = Tax[i] - Tax[j]
            if abs(Euc[i] - Euc[j]) < tau
                RA[i, j] = 0
            else
                RA[i, j] = 1
            end
        end
    end

    scores = Vector{Any}(undef, nrows)
    for i = 1:nrows
        scores[i] = sum(EA[i, :] .+ (RA[i, :] .* TA[i, :]))
    end

    rankings = sortperm(scores)
    bestIndex = rankings |> last

    result = CODASResult(
        decisionMat, 
        A,              # normalized matrix
        wA,             # weighted normalized matrix
        w, 
        E, 
        Euc,
        T,
        Tax,
        EA, 
        TA, 
        RA,
        scores, 
        rankings, 
        bestIndex)

    return result
end

"""
    codas(setting; tau = 0.02)
    
Apply CODAS (COmbinative Distance-based ASsessment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 - `tau::Float64`: tau parameter for the algorithm. The default is 0.02.

 # Description 
codas() applies the CODAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::CODASResult`: CODASResult object that holds multiple outputs including scores and best index.
"""
function codas(setting::MCDMSetting; tau::Float64 = 0.02)::CODASResult
    codas(setting.df, setting.weights, setting.fns, tau = tau)
end






end # end of module CODAS 
