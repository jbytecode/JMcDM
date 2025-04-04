module MEREC

export merec, MERECResult, MERECMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations 

using ..Utilities



struct MERECMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

MERECMethod() = MERECMethod(Normalizations.inversedividebycolumnmaxminnormalization)


struct MERECResult <: MCDMResult
    decisionMatrix::Matrix
    w::Vector
end



"""
merec(decisionMat, fns; normalization)

Apply MEREC (MEthod based on the Removal Effects of Criteria) for a given matrix and criteria types.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.
 - `normalization{<:Function}`: Optional normalization function.

# Description 
merec() applies the MEREC method to calculate weights using a decision matrix with  
n alternatives subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::MERECResult`: MERECResult object that holds multiple outputs including weights.

# Examples
```julia-repl

julia> decisionMat = DataFrame(
                   :K1 => [450, 10, 100, 220, 5],
                   :K2 => [8000, 9100, 8200, 9300, 8400],
                   :K3 => [54, 2, 31, 1, 23],
                   :K4 => [145, 160, 153, 162, 158]
               )
5×4 DataFrame
 Row │ K1     K2     K3     K4    
     │ Int64  Int64  Int64  Int64 
─────┼────────────────────────────
   1 │   450   8000     54    145
   2 │    10   9100      2    160
   3 │   100   8200     31    153
   4 │   220   9300      1    162
   5 │     5   8400     23    158

julia> fs = [maximum, maximum, minimum, minimum];

julia> result = merec(decisionMat, fs);

julia> result.w
4-element Vector{Float64}:
 0.5752216672093823
 0.01409659116846726
 0.40156136388773117
 0.009120377734419302

```
# References

Keshavarz-Ghorabaee, M., Amiri, M., Zavadskas, E. K., Turskis, Z., & Antucheviciene, J. (2021). Determination of Objective Weights Using a New Method Based on the Removal Effects of Criteria (MEREC). Symmetry, 13(4), 525. https://doi.org/10.3390/sym13040525

"""
function merec(
    decisionMat::Matrix, 
    fs::Array{F,1};
    normalization::G = Normalizations.inversedividebycolumnmaxminnormalization
    )::MERECResult where {F<:Function, G<:Function}

    row, col = size(decisionMat)

    NormalizeMatrix = normalization(decisionMat, fs)


    S = zeros(row)
    S_ = zeros(row, col)

    @inbounds for i = 1:row
        for j = 1:col
            S[i] = log(1 + (sum(abs.(map(log, NormalizeMatrix[i, :]))) / col))
        end
    end

    @inbounds for i = 1:row
        for j = 1:col
            S_[i, j] = log(
                1 + (
                    (
                        sum(abs.(map(log, NormalizeMatrix[i, :]))) -
                        abs(log(NormalizeMatrix[i, j]))
                    ) / col
                ),
            )
        end
    end

    E = zeros(col)

    @inbounds for i = 1:row
        for j = 1:col
            E[j] = sum(abs.(S_[:, j] .- S))
        end
    end

    w = zeros(col)

    w = E ./ sum(E)

    result = MERECResult(decisionMat, w)

    return result

end


"""
        merec(setting)

Apply MEREC (MEthod based on the Removal Effects of Criteria) for a given matrix and criteria types.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
merec() applies the MEREC method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MERECResult`: MERECResult object that holds multiple outputs including weighting and best index.
"""
function merec(setting::MCDMSetting)::MERECResult
    merec(setting.df, setting.fns)
end



end # end of module MEREC
