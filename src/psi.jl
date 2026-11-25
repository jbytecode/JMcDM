module PSI

export psi, PSIMethod, PSIResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations 

using ..Utilities



struct PSIResult <: MCDMResult
    pvs::Vector
    phis::Vector
    psis::Vector
    scores::Vector
    rankings::Array{Int,1}
    bestIndex::Int
end

struct PSIMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

PSIMethod() = PSIMethod(Normalizations.dividebycolumnmaxminnormalization)



"""
        psi(decisionMat, fns; normalization)

Apply PSI (Preference Selection Index) method for a given matrix and directions of optimizations.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns.
 - `normalization{<:Function}`: Optional normalization function.
 
# Description 
psi() applies the PSI method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::PSIResult`: PSIResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [3        12.5        2        120        14        3;
       5        15        3        110        38        4;
       3        13        2        120        19        3;
       4        14        2        100        31        4;
       3        15        1.5        125        40        4]
5×6 Array{Float64,2}:
 3.0  12.5  2.0  120.0  14.0  3.0
 5.0  15.0  3.0  110.0  38.0  4.0
 3.0  13.0  2.0  120.0  19.0  3.0
 4.0  14.0  2.0  100.0  31.0  4.0
 3.0  15.0  1.5  125.0  40.0  4.0



julia> fns = [maximum, minimum, minimum, maximum, minimum, maximum];

julia> result = psi(decmat, fns)
Scores:
[0.8421858156597993, 0.7833966527312931, 0.8011549399477343, 0.798758294297656, 0.8197548833703039]
Ordering: (from worst to best)
[2, 4, 3, 5, 1]
Best indices:
1

julia> result.bestIndex 
1
```

# References
Maniya, Kalpesh, and Mangal Guido Bhatt. "A selection of material using a novel type decision-making method: 
Preference selection index method." Materials & Design 31.4 (2010): 1785-1789
"""
function psi(
    decisionMat::Matrix, 
    fns::Array{F,1};
    normalization::G = Normalizations.dividebycolumnmaxminnormalization
    )::PSIResult where {F<:Function, G<:Function}

    function PV(v)
        mymean = mean(v)
        meandiff = v .- mymean
        meandiffsq = meandiff .* meandiff
        return sum(meandiffsq)
    end

    row, col = size(decisionMat)

    zerotype = eltype(decisionMat)

    #colminmax = zeros(zerotype, col)

    normalizedDecisionMat = normalization(decisionMat, fns)

    # Preference variation, its deviation and the overall preference value are
    # defined per criterion (Maniya and Bhatt 2010); psis are the criterion weights.
    pvs = zeros(zerotype, col)
    for j = 1:col
        pvs[j] = PV(normalizedDecisionMat[:, j] |> collect)
    end

    phis = one(zerotype) .- pvs
    sum_phis = sum(phis)

    psis = phis ./ sum_phis

    Is = zeros(zerotype, row)
    for i = 1:row
        Is[i] = psis .* collect(normalizedDecisionMat[i, :]) |> sum
    end

    scores = Is
    ranks = sortperm(scores)
    bestindex = ranks |> last

    result = PSIResult(pvs, phis, psis, scores, ranks, bestindex)

    return result
end


"""
        psi(setting)

Apply PSI (Preference Selection Index) method for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 

# Description 
psi() applies the PSI method to rank n alternatives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::PSIResult`: PSIResult object that holds multiple outputs including scores, rankings, and best index.
"""
function psi(setting::MCDMSetting)::PSIResult
    psi(setting.df, setting.fns)
end


end # end of module PSI 
