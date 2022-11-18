module SCDM

export LaplaceResult, MaximinResult, MaximaxResult, MinimaxResult, MiniminResult
export SavageResult, HurwiczResult, MLEResult, ExpectedRegretResult
export laplace, maximax, maximin, minimax, minimin, savage, hurwicz, mle, expectedregret

import ..SCDMResult
using ..Utilities


struct LaplaceResult <: SCDMResult
    expected_values::Array{Float64,1}
    bestIndex::Int64
end

struct MaximinResult <: SCDMResult
    rowmins::Array{Float64,1}
    bestIndex::Int64
end


struct MaximaxResult <: SCDMResult
    rowmaxs::Array{Float64,1}
    bestIndex::Int64
end

struct MinimaxResult <: SCDMResult
    rowmaxs::Array{Float64,1}
    bestIndex::Int64
end

struct MiniminResult <: SCDMResult
    rowmins::Array{Float64,1}
    bestIndex::Int64
end

struct SavageResult <: SCDMResult
    regretMatrix::Matrix
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct HurwiczResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct MLEResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

struct ExpectedRegretResult <: SCDMResult
    scores::Array{Float64,1}
    bestIndex::Int64
end

"""
    laplace(decisionMat)

    Apply Laplace method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::LaplaceResult`: LaplaceResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        3000 2750 2500 2250;
        1500 4750 8000 7750;
        2000 5250 8500 11750
]

julia> result = laplace(mat)
```
"""
function laplace(decisionMatrix::Matrix)::LaplaceResult

    n, p = size(decisionMatrix)

    probs = [1.0 / p for i = 1:p]

    expecteds = zeros(Float64, n)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)

    for i = 1:n
        expecteds[i] = (m[i, :] .* probs) |> sum
    end

    bestIndex = sortperm(expecteds) |> last

    result = LaplaceResult(expecteds, bestIndex)

    return result
end



"""
    maximin(decisionMat)

    Apply Maximin method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::MaximinResult`: MaximinResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

julia> result = maximin(mat)
```
"""
function maximin(decisionMatrix::Matrix)::MaximinResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)

    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> last

    result = MaximinResult(rmins, bestIndex)

    return result
end


"""
    maximax(decisionMat)

    Apply Maximax method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::MaximaxResult`: MaximaxResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]


julia> result = maximax(mat)
```
"""
function maximax(decisionMatrix::Matrix)::MaximaxResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> last

    result = MaximaxResult(rmaxs, bestIndex)

    return result
end


"""
    minimax(decisionMat)

    Apply Minimax method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::MinimaxResult`: MinimaxResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]


julia> result = minimax(mat)
```
"""
function minimax(decisionMatrix::Matrix)::MinimaxResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> first

    result = MinimaxResult(rmaxs, bestIndex)

    return result
end



"""
    minimin(decisionMat)

    Apply Minimin method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::MiniminResult`: Minimin object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

julia> result = minimin(mat)
```
"""
function minimin(decisionMatrix::Matrix)::MiniminResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)

    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> first

    result = MiniminResult(rmins, bestIndex)

    return result
end


"""
    savage(decisionMat)

    Apply Savage method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::SavageResult`: SavageResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]


julia> result = savage(mat)

julia> result.bestIndex 
4
```
"""
function savage(decisionMatrix::Matrix)::SavageResult

    n, p = size(decisionMatrix)

    cmaxs = colmaxs(decisionMatrix)

    newDecisionMatrix = similar(decisionMatrix)

    @inbounds for i = 1:p
        newDecisionMatrix[:, i] = cmaxs[i] .- decisionMatrix[:, i]
    end

    rmaxs = scores = rowmaxs(newDecisionMatrix)

    bestIndex = rmaxs |> sortperm |> first

    result = SavageResult(newDecisionMatrix, scores, bestIndex)

    return result
end


"""
    hurwicz(decisionMat; alpha = 0.5)

    Apply Hurwicz method for a given decision matrix (for convenience, in type of Matrix).

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 - `alpha::Float64`: The optional alpha value for the Hurwicz method. Default is 0.5.
 
# Output 
- `::HurwiczResult`: HurwiczResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

julia> result = hurwicz(mat)

julia> result.bestIndex 
3
```
"""
function hurwicz(decisionMatrix::Matrix; alpha::Float64 = 0.5)::HurwiczResult

    n, p = size(decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)
    rmins = rowmins(decisionMatrix)

    scores = alpha .* rmaxs .+ (1.0 - alpha) .* rmins

    bestIndex = scores |> sortperm |> last

    result = HurwiczResult(scores, bestIndex)

    return result

end



"""
    mle(decisionMat, weights)

    Apply MLE (Maximum Likelihood) method for a given decision matrix (for convenience, in type of Matrix) and weights.

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 - `weights::Array{Float64,1}`: Array of weights for each criterion that sums up to 1.0.
 
# Output 
- `::MLEResult`: MLEResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]


julia> weights = [0.2, 0.5, 0.2, 0.1]
julia> result = mle(mat, weights)

julia> result.bestIndex 
2
```
"""
function mle(decisionMatrix::Matrix, weights::Array{Float64,1})::MLEResult


    weightedMatrix = Utilities.weightise(decisionMatrix, weights)
    

    scores = rowsums(weightedMatrix)

    bestIndex = scores |> sortperm |> last

    result = MLEResult(scores, bestIndex)

    return result

end



"""
    expectedregret(decisionMat, weights)

    Apply Expected Regret method for a given decision matrix (for convenience, in type of Matrix) and weights.

# Arguments:
 - `decisionMat::Matrix`: Decision matrix with n alternatives and m criteria. 
 - `weights::Array{Float64,1}`: Array of weights for each criterion that sums up to 1.0.
 
# Output 
- `::ExpectedRegretResult`: ExpectedRegretResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

julia> weights = [0.2, 0.5, 0.2, 0.1]
julia> result = expectedregret(mat, weights)

julia> result.bestIndex 
2
```
"""
function expectedregret(decisionMatrix::Matrix, weights::Array{Float64,1})

    _, p = size(decisionMatrix)

    w = unitize(weights)

    cmaxs = colmaxs(decisionMatrix)

    regretmat = similar(decisionMatrix)

    for i = 1:p
        regretmat[:, i] = cmaxs[i] .- decisionMatrix[:, i]
    end

    weightedregret = Utilities.weightise(regretmat, w)

    scores = rowsums(weightedregret)

    bestIndex = scores |> sortperm |> first

    result = ExpectedRegretResult(scores, bestIndex)

    return result
end







end # end of module SCM 
