module OCRA

export ocra, OCRAResult, OCRAMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting

using ..Utilities

struct OCRAResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

"""
    ocra(decisionMat, weights, fns)

Apply ORCA (Operational Competitiveness RAting) for a given matrix and weights.

# Arguments:
 - `decisionMat::Matrix`: m × n matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: n-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: n-vector of functions to be applied on the columns. 

# Description 
ocra() applies the OCRA method to rank m alternatives subject to n criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::OCRAResult`: OCRAResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decMat = [
            8.0  16.0  1.5  1.2   4200.0  5.0  5.0  314.0  185.0;
            8.0  16.0  1.0  1.3   4200.0  5.0  4.0  360.0  156.0;
           10.1  16.0  2.0  1.3   4060.0  5.0  3.0  503.0  160.0;
           10.1   8.0  1.0  1.5   5070.0  2.0  4.0  525.0  200.0;
           10.0  16.0  2.0  1.2   6350.0  5.0  3.0  560.0  190.0;
           10.1  16.0  1.0  1.2   5500.0  2.0  2.0  521.0  159.0;
           10.1  64.0  2.0  1.7   5240.0  5.0  3.0  770.0  199.0;
            7.0  32.0  1.0  1.8   3000.0  3.0  4.0  364.0  157.0;
           10.1  16.0  1.0  1.3   3540.0  5.0  3.0  510.0  171.0;
            9.7  16.0  2.0  1.83  7500.0  6.0  2.0  550.0  170.0
       ]
10×9 Matrix{Float64}:
  8.0  16.0  1.5  1.2   4200.0  5.0  5.0  314.0  185.0
  8.0  16.0  1.0  1.3   4200.0  5.0  4.0  360.0  156.0
 10.1  16.0  2.0  1.3   4060.0  5.0  3.0  503.0  160.0
 10.1   8.0  1.0  1.5   5070.0  2.0  4.0  525.0  200.0
 10.0  16.0  2.0  1.2   6350.0  5.0  3.0  560.0  190.0
 10.1  16.0  1.0  1.2   5500.0  2.0  2.0  521.0  159.0
 10.1  64.0  2.0  1.7   5240.0  5.0  3.0  770.0  199.0
  7.0  32.0  1.0  1.8   3000.0  3.0  4.0  364.0  157.0
 10.1  16.0  1.0  1.3   3540.0  5.0  3.0  510.0  171.0
  9.7  16.0  2.0  1.83  7500.0  6.0  2.0  550.0  170.0

julia> weights =[0.167, 0.039, 0.247, 0.247, 0.116, 0.02, 0.056, 0.027, 0.081];

julia> fns = [maximum,maximum,maximum,maximum,maximum,maximum,maximum,minimum,minimum];

julia> result = ocra(decmat, weights, fns);

julia> result.scores
10-element Vector{Float64}:
 0.14392093908214929
 0.024106550710436096
 0.27342011595623067
 0.04297916544177691
 0.31851953804157623
 0.0024882426914910674
 0.5921715172301161
 0.11390289470614312
 0.0
 0.47874854984718046

julia> result.bestIndex
7

```

# References

- Parkan, C. (1994). Operational competitiveness ratings of production units. Managerial and Decision Economics, 15(3), 201–221. doi:10.1002/mde.4090150303 
- Parkan, C. (2003). Measuring the effect of a new point of sale system on the performance of drugstore operations. Computers & Operations Research, 30(5), 729–744. doi:10.1016/s0305-0548(02)00047-3 
- Kundakcı, N. (2017). An Integrated Multi-Criteria Decision Making Approach for Tablet Computer Selection. European Journal of Multidisciplinary Studies, 2(5), 31-43.

"""
function ocra(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
)::OCRAResult where {F<:Function}

    row, col = size(decisionMat)
    w = unitize(weights)
    zerotype = eltype(decisionMat)
    I1 = zeros(zerotype, row)
    I2 = zeros(zerotype, row)
    O1 = zeros(zerotype, row)
    O2 = zeros(zerotype, row)
    scores  = zeros(zerotype, row)

    colMax = colmaxs(decisionMat)
    colMin = colmins(decisionMat)

    for i = 1:row
        for j = 1:col
            if fns[j] == minimum
                I1[i] += w[j]*(colMax[j] - decisionMat[i,j])/colMin[j]
            else
                O1[i] += w[j]*(decisionMat[i,j] - colMin[j])/colMin[j]
            end
        end
    end

    I2 = I1 .- minimum(I1)
    O2 = O1 .- minimum(O1)
    scores = I2 .+ O2
    scores = scores .- minimum(scores)

    rankings = sortperm(scores)

    bestIndex = rankings |> last

    result = OCRAResult(decisionMat, w, scores, rankings, bestIndex)

    return result
end

"""
    ocra(setting)

Apply OCRA (Operational Competitiveness RAting) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
ocra() applies the OCRA method to rank m alternatives subject to n criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::OCRAResult`: OCRAResult object that holds multiple outputs including scores, rankings, and best index.
"""
function ocra(setting::MCDMSetting)::OCRAResult
    ocra(setting.df, setting.weights, setting.fns)
end

end # end of module OCRA 
