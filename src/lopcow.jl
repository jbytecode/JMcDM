# LOPCOW
module LOPCOW

export lopcow, LOPCOWResult, LOPCOWMethod

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities

struct LOPCOWMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

LOPCOWMethod() = LOPCOWMethod(Normalizations.maxminrangenormalization)

struct LOPCOWResult <: MCDMResult
    decisionMatrix::Matrix
    w::Vector
end

"""
    lopcow(decisionMat, fns; normalization)

Apply LOPCOW (LOgarithmic Percentage Change-driven Objective Weighting) method for a given matrix and criteria types.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.
 - `normalization{<:Function}`: Optional normalization function.

# Description 
lopcow() applies the LOPCOW method to calculate objective weights using a decision matrix with  
n alterntives subject to m criteria which are supposed to be either maximized or minimized.

# Output 
- `::LOPCOWResult`: LOPCOWResult object that holds multiple outputs including weighting and best index.

# Examples
```julia-repl

julia> decmat
9×17 Matrix{Float64}:
 21.8  14.1  10.7  1.6  1.8   770.0  12750.0  18.0   5100.0  1.5     9.1    1.054  4.196  29.407   7.03   15.08    9.705
 16.4   8.5  13.9  1.2  1.3   524.0  12087.0   5.7   2941.0  2.208  15.2    1.123  3.86    5.228  14.724  32.103  19.0
 14.5   7.0   2.3  0.2  0.2   238.0   3265.0   1.9    320.0  2.32   16.202  1.008  3.095   5.549  17.34   65.129  32.056
 18.2  10.3  11.4  1.2  1.1   835.0  16037.0  21.3   4332.0  0.875   9.484  0.856  2.191  23.75   13.1    58.157  27.46
 18.5   8.1  11.1  1.0  1.1   504.0   9464.0   1.4   1743.0  2.95    0.7    0.479  2.44    8.77   13.48   33.45   17.68
 18.7  11.4  10.8  1.3  1.5  1227.0  24053.0  20.0   6521.0  0.733   1.6    0.857  2.377   4.985  11.743  26.732  24.485
 18.5  12.6  10.8  1.4  1.8   912.0  18800.0  18.2   5300.0  1.29    8.27   0.558  0.635   5.22   13.829  31.914   7.515
 16.4   6.7  12.6  0.9  0.9   951.0  16767.0  22.0   3917.0  2.46    3.9    0.724  0.568   4.491  14.357  28.869   7.313
 15.2   6.3   6.9  0.5  0.5  1013.0  20170.0  10.97  4060.0  1.67    1.7    0.704  2.96    3.24   10.029  60.981  23.541

julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum, minimum, minimum, minimum, minimum, minimum, minimum ];

julia> result = lopcow(decmat, fns);

julia> result.w
17-element Vector{Float64}:
 0.04947396185854988
 0.036623078374935315
 0.08456624432002027
 0.07055941647198624
 ⋮
 0.07625360895444118
 0.05507171491276535
 0.05320727577078255
 0.05340460620185558

```
# References

Ecer, F., & Pamucar, D. (2022). A novel LOPCOW‐DOBI multi‐criteria sustainability performance assessment methodology: An application in developing country banking sector. Omega, 112, 102690. https://doi.org/10.1016/j.omega.2022.102690

"""
function lopcow(
    decisionMat::Matrix, 
    fns::Array{F,1}; 
    normalization::G = Normalizations.maxminrangenormalization
    )::LOPCOWResult where {F<:Function, G<:Function}

    row, col = size(decisionMat)

    zerotype = eltype(decisionMat[:, 1])

    normalizedMat = normalization(decisionMat, fns)

    PV = zeros(zerotype, col)

    for i = 1:col
        PV[i] = log(sqrt(sum(normalizedMat[:,i].*normalizedMat[:,i])/row)/std(normalizedMat[:,i]))*100
    end

    w = zeros(zerotype, col)

    for i = 1:col
        w[i] = PV[i] ./ sum(PV)
    end

    result = LOPCOWResult(decisionMat, w)

    return result
end

"""
    lopcow(setting)

Apply LOPCOW (LOgarithmic Percentage Change-driven Objective Weighting) method for a given matrix and criteria types.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
lopcow() applies the LOPCOW method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::LOPCOWResult`: LOPCOWResult object that holds multiple outputs including weighting and best index.
"""
function lopcow(setting::MCDMSetting)::LOPCOWResult
    lopcow(setting.df, setting.fns)
end

end # end of module LOPCOW