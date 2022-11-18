module SAW

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities

export saw, SawResult, SawMethod



struct SawMethod <: MCDMMethod end

struct SawResult <: MCDMResult
    decisionMatrix::Matrix
    normalizedDecisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

function Base.show(io::IO, result::SawResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end


"""
        saw(decisionMat, weights, fns)

Apply SAW (Simple Additive Weighting) method for a given matrix and weights.
This method also known as WSM (Weighted Sum Model)

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{<:Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
saw() applies the SAW method to rank n strategies subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::SawResult`: SawResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [4.0  7  3  2  2  2  2;
                 4.0  4  6  4  4  3  7;
                 7.0  6  4  2  5  5  3;
                 3.0  2  5  3  3  2  5;
                 4.0  2  2  5  5  3  6];

julia> fns = [maximum for i in 1:7];

julia> weights = [0.283, 0.162, 0.162, 0.07, 0.085, 0.162, 0.076];

julia> result = saw(decmat, weights, fns);

julia> result.scores
5-element Array{Float64,1}:
 0.5532285714285714
 0.7134857142857142
 0.8374285714285714
 0.5146571428571429
 0.5793428571428572

julia> result.bestIndex
3
```

# References
Afshari, Alireza, Majid Mojahed, and Rosnah Mohd Yusuff. "Simple additive weighting approach to 
personnel selection problem." International Journal of Innovation, Management and Technology 
1.5 (2010): 511.
"""
function saw(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1},
)::SawResult where {F<:Function}

    n, p = size(decisionMat)

    normalizedDecisionMat = similar(decisionMat)

    w = unitize(weights)

    zerotype = eltype(decisionMat)

    colminmax = zeros(zerotype, p)

    @inbounds for i = 1:p
        colminmax[i] = decisionMat[:, i] |> fns[i]
        if fns[i] == maximum
            normalizedDecisionMat[:, i] = decisionMat[:, i] ./ colminmax[i]
        elseif fns[i] == minimum
            normalizedDecisionMat[:, i] = colminmax[i] ./ decisionMat[:, i]
        else
            @error fns[i]
            error("Function not found")
        end
    end

    # scores = w * normalizedDecisionMat |> rowsums
    scores = Utilities.weightise(normalizedDecisionMat, w) |> rowsums
    
    rankings = scores |> sortperm |> reverse

    bestIndex = rankings |> first

    result = SawResult(decisionMat, normalizedDecisionMat, w, scores, rankings, bestIndex)

    return result
end

"""
        saw(setting)

Apply SAW (Simple Additive Weighting) method for a given matrix and weights.
This method also known as WSM (Weighted Sum Model)

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
# Description 
saw() applies the SAW method to rank n strategies subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::SawResult`: SawResult object that holds multiple outputs including scores, rankings, and best index.
"""
function saw(setting::MCDMSetting)::SawResult
    saw(setting.df, setting.weights, setting.fns)
end



end # end of module SAW
