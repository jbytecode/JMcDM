"""
    laplace(decisionMat)

    Apply Laplace method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
# Output 
- `::LaplaceResult`: LaplaceResult object that holds multiple outputs including the best alternative.

# Examples
```julia-repl
julia> mat = [
        3000 2750 2500 2250;
        1500 4750 8000 7750;
        2000 5250 8500 11750
]

julia> dm = makeDecisionMatrix(mat)

julia> result = laplace(dm)
```
"""
function laplace(decisionMatrix::DataFrame)::LaplaceResult

    n, p = size(decisionMatrix)

    probs = [1.0 / p for i in 1:p]

    expecteds = zeros(Float64, n)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)
    
    for i in 1:n
        expecteds[i] = (m[i,:] .* probs)  |> sum
    end

    bestIndex = sortperm(expecteds) |> last

    result = LaplaceResult(
        expecteds,
        bestIndex
    )

    return result
end



"""
    maximin(decisionMat)

    Apply Maximin method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = maximin(dm)
```
"""
function maximin(decisionMatrix::DataFrame)::MaximinResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)
    
    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> last

    result = MaximinResult(
        rmins,
        bestIndex
    )

    return result
end


"""
    maximax(decisionMat)

    Apply Maximax method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = maximax(dm)
```
"""
function maximax(decisionMatrix::DataFrame)::MaximaxResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)
    
    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> last

    result = MaximaxResult(
        rmaxs,
        bestIndex
    )

    return result
end


"""
    minimax(decisionMat)

    Apply Minimax method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = minimax(dm)
```
"""
function minimax(decisionMatrix::DataFrame)::MinimaxResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)
    
    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> first

    result = MinimaxResult(
        rmaxs,
        bestIndex
    )

    return result
end



"""
    minimin(decisionMat)

    Apply Minimin method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = minimin(dm)
```
"""
function minimin(decisionMatrix::DataFrame)::MiniminResult

    n, p = size(decisionMatrix)

    # m = convert(Array{Float64,2}, decisionMatrix)
    m = Matrix{Float64}(decisionMatrix)
    
    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> first

    result = MiniminResult(
        rmins,
        bestIndex
    )

    return result
end


"""
    savage(decisionMat)

    Apply Savage method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = savage(dm)

julia> result.bestIndex 
4
```
"""
function savage(decisionMatrix::DataFrame)::SavageResult

    n, p = size(decisionMatrix)

    cmaxs = colmaxs(decisionMatrix)

    newDecisionMatrix = similar(decisionMatrix)

    @inbounds for i in 1:p
        newDecisionMatrix[:, i] = cmaxs[i] .- decisionMatrix[:, i]
    end

    rmaxs = scores = rowmaxs(newDecisionMatrix)

    bestIndex = rmaxs |> sortperm |> first

    result = SavageResult(
        newDecisionMatrix,
        scores,
        bestIndex
    )

    return result
end


"""
    hurwicz(decisionMat; alpha = 0.5)

    Apply Hurwicz method for a given decision matrix (for convenience, in type of DataFrame).

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
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

julia> dm = makeDecisionMatrix(mat)

julia> result = hurwicz(dm)

julia> result.bestIndex 
3
```
"""
function hurwicz(decisionMatrix::DataFrame; alpha::Float64=0.5)::HurwiczResult

    n, p = size(decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)
    rmins = rowmins(decisionMatrix)

    scores = alpha .* rmaxs .+ (1.0 - alpha) .* rmins
    
    bestIndex = scores |> sortperm |>  last 

    result = HurwiczResult(
        scores,
        bestIndex
    )

    return result

end



"""
    mle(decisionMat, weights)

    Apply MLE (Maximum Likelihood) method for a given decision matrix (for convenience, in type of DataFrame) and weights.

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
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

julia> dm = makeDecisionMatrix(mat)
julia> weights = [0.2, 0.5, 0.2, 0.1]
julia> result = mle(dm)

julia> result.bestIndex 
2
```
"""
function mle(decisionMatrix::DataFrame, weights::Array{Float64,1})::MLEResult

    w = unitize(weights)
    
    weightedMatrix = w * decisionMatrix

    scores = rowsums(weightedMatrix)

    bestIndex = scores |> sortperm |> last

    result = MLEResult(
        scores,
        bestIndex
    )
    
    return result 

end



"""
    expectedregret(decisionMat, weights)

    Apply Expected Regret method for a given decision matrix (for convenience, in type of DataFrame) and weights.

# Arguments:
 - `decisionMat::DataFrame`: Decision matrix with n alternatives and m criteria. 
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

julia> dm = makeDecisionMatrix(mat)
julia> weights = [0.2, 0.5, 0.2, 0.1]
julia> result = expectedregret(dm)

julia> result.bestIndex 
2
```
"""
function expectedregret(decisionMatrix::DataFrame, weights::Array{Float64,1})

    _, p = size(decisionMatrix)
    
    w = unitize(weights)

    cmaxs = colmaxs(decisionMatrix)

    regretmat = similar(decisionMatrix)

    for i in 1:p
        regretmat[:, i] = cmaxs[i] .- decisionMatrix[:, i]
    end

    weightedregret = w * regretmat 

    scores = rowsums(weightedregret)

    bestIndex = scores |> sortperm |> first 

    result = ExpectedRegretResult(
        scores,
        bestIndex
    )

    return result
end






