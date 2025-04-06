
module LMAW

export lmaw, LMAWResult, LMAWMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations 

using ..Utilities

struct LMAWResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

struct LMAWMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

LMAWMethod() = LMAWMethod(Normalizations.dividebycolumnmaxminnormalization)

"""
    lmaw(decisionMat, weights, fns; normalization)

Apply LMAW (Logarithm Methodology of Additive Weights) for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: m × n matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: n-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: n-vector of functions to be applied on the columns.
 - `normalization{<:Function}`: Optional normalization function.

# Description 
lmaw() applies the LMAW method to rank m alternatives subject to n criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::LMAWResult`: LMAWResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decMat = [
                647.34        6.24        49.87        19.46        212.58        6.75;
                115.64        3.24        16.26         9.69        207.59        3.00;
                373.61        5.00        26.43        12.00        184.62        3.74;
                 37.63        2.48         2.85         9.25        142.50        3.24;
                858.01        4.74        62.85        45.96        267.95        4.00;
                222.92        3.00        19.24        21.46        221.38        3.49
                ]   
       6×6 Matrix{Float64}:
       647.34  6.24  49.87  19.46  212.58  6.75
       115.64  3.24  16.26   9.69  207.59  3.0
       373.61  5.0   26.43  12.0   184.62  3.74
        37.63  2.48   2.85   9.25  142.5   3.24
       858.01  4.74  62.85  45.96  267.95  4.0
       222.92  3.0   19.24  21.46  221.38  3.49

julia> weights = [0.215, 0.126, 0.152, 0.091, 0.19, 0.226];

julia> fns = [maximum, maximum, minimum, minimum, minimum, maximum];

julia> result = lmaw(decmat, weights, fns);

julia> result.scores
6-element Vector{Float64}:
 4.839005264308832
 4.679718180594332
 4.797731427991642
 4.732145373983716
 4.73416833375772
 4.702247270959649

julia> result.bestIndex
1
```

# References

- Pamučar, D., Žižović, M., Biswas, S., & Božanić, D. (2021). A new logarithm methodology of additive weights (LMAW) for multi-criteria decision-making: Application in logistics. Facta Universitatis, Series: Mechanical Engineering, 19(3), 361. https://doi.org/10.22190/FUME210214031P

"""
function lmaw(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.dividebycolumnmaxminnormalization
)::LMAWResult where {F<:Function, G<:Function}

    row, col = size(decisionMat)

    w = unitize(weights)
    
    A = normalization(decisionMat, fns) .+1

    zerotype = eltype(A)

    Q = zeros(zerotype, row, col)

    N = log.(A)

    a = log.(apply_columns(prod, A))

    scores = zeros(zerotype, row)
    
    for j=1:col
        N[:,j] = N[:,j]./ a[j]
        Q[:,j] = (2 .* N[:,j] .^ w[j]) ./ ((2 .- N[:,j]) .^ w[j] + N[:,j] .^ w[j])
    end
    
    for i = 1:row
        scores[i] = sum(Q[i, :])
    end

    rankings = sortperm(scores)

    bestIndex = rankings |> last

    result = LMAWResult(decisionMat, w, scores, rankings, bestIndex)

    return result
end

"""
    lmaw(setting)

Apply LMAW (Logarithm Methodology of Additive Weights) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
lmaw() applies the LMAW method to rank m alternatives subject to n criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::LMAWResult`: LMAWResult object that holds multiple outputs including scores, rankings, and best index.
"""
function lmaw(setting::MCDMSetting)::LMAWResult
    lmaw(setting.df, setting.weights, setting.fns)
end

end # end of module LMAW 
