module TODIM
import ..MCDMMethod, ..MCDMResult, ..MCDMSetting

export TODIMMethod, TODIMResult, todim

struct TODIMMethod <: MCDMMethod end

struct TODIMResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

"""
    AMatConstructor(decisionMat::Matrix, fns::Array{F,1})::Matrix where {F<:Function}

Construct the A matrix for TODIM method.
A matrix is a matrix of decision criteria that is comprised of values in the range of 1 to \
10. `AMatConstructor` assigns a score of 10 to an alternative if the corresponding value of \
alternative is among the top 10% of the values of that criterion and assigns a score of 9 \
to an alternative if the corresponding value of alternative is among the top [80% 90%) of \
the values of that criterion and so on.

# Arguments
- `decisionMat::Matrix`: A matrix of decision criteria. It's assumed that the criteria are
  in the columns and alternatives are in the rows.
- `fns::Array{F,1}`: A vector of functions that specifies the Beneficial Criteria (BC) as \
`maximum` and the non-Beneficial Criteria (NC) as `minimum`.

# Returns
- `Matrix`: A matrix of decision criteria that is comprised of values in the range of 0 to 10.

# Example
```julia
julia> mat = [
           1.0     0.9925;
           0.8696  0.8271;
           0.7391  0.8684;
           0.5217  0.7895;
           0.6522  0.9135;
           0.6087  0.8346;
           0.913   0.185
       ];

julia> fns = [maximum, minimum];

julia> A = AMatConstructor(mat, fns)
7×2 Matrix{Float64}:
 10.0   1.0
  7.0   7.0
  6.0   4.0
  1.0   9.0
  4.0   3.0
  3.0   6.0
  9.0  10.0
```
"""
function AMatConstructor(decisionMat::Matrix, fns::Array{F,1})::Matrix where {F<:Function}
    size(decisionMat, 2) == length(fns) || DimensionMismatch("The number of functions must
    be equal to the number of columns of decision matrix.") |> throw
    all(func -> func ∈ (maximum, minimum), fns) || ArgumentError("The functions must be either
    `maximum` or `minimum`.") |> throw

    n, m = size(decisionMat)
    A = zeros(n, m)
    for j in 1:m

        vals = decisionMat[:,j]
        if fns[j] == minimum
            for i in 1:n
                A[i,j] = sum(vals .>= decisionMat[i,j]) / n * 10 |> round
            end
        else
            for i in 1:n
                A[i,j] = sum(vals .<= decisionMat[i,j]) / n * 10 |> round
            end
        end
    end
    return A
end

"""
    normalizedAMatrix!(AMatrix::Matrix)::Matrix where {F<:Function}

Apply min max normalization to the A matrix using the following formula:
``N_{ij} = \\frac{A_{ij} - min(A_j)}{max(A_j) - min(A_j)}``

# Arguments
- `AMatrix::Matrix`: A matrix of decision criteria that is comprised of values in the range \
of 1 to 10.

# Returns
- `Matrix`: A matrix of decision criteria that is comprised of values in the range of 0 to 1.

# Example
```julia
julia> mat = [
           1.0     0.9925;
           0.8696  0.8271;
           0.7391  0.8684;
           0.5217  0.7895;
           0.6522  0.9135;
           0.6087  0.8346;
           0.913   0.185
       ];

julia> fns = [maximum, minimum];

julia> foo = AMatConstructor(mat, fns);

julia> bar = normalizedAMatrix!(foo)
7×2 Matrix{Float64}:
 1.0       0.0
 0.666667  0.666667
 0.555556  0.333333
 0.0       0.888889
 0.333333  0.222222
 0.222222  0.555556
 0.888889  1.0
```
"""
function normalizedAMatrix!(AMatrix::Matrix)::Matrix
    n, m     = size(AMatrix)
    for j in 1:m
        max_ = maximum(AMatrix[:,j])
        min_ = minimum(AMatrix[:,j])
        # Apply min max normalization
        AMatrix[:,j] .= (AMatrix[:,j] .- min_)./(max_ .- min_)
    end
    return AMatrix
end

"""
    criteriaWeights!(w::Vector)::Vector

Evaluate the importance of each criterion using AHP approach.

# Arguments
- `w::Vector`: A vector of weights of criteria.

# Returns
- `Vector`: Evaluated vector of weights of criteria.

# Example
```julia
julia> w = [2, 3, 8];

julia> w2 = criteriaWeights(w)
3-element Vector{Float64}:
 0.15384615384615385
 0.23076923076923078
 0.6153846153846154

julia> sum(w2)
1.0
```
"""
function criteriaWeights(w::Vector)::Vector
    denom       = repeat(w, 1, length(w))
    compar      = w./denom'
    imp_weights = reduce(*, compar, dims=1).^(-1/length(w)) |> vec
    weights     = imp_weights./sum(imp_weights)
    @assert isapprox(sum(weights), 1.0) "The sum of weights should be equal to 1."
    return weights
end

"""
    dominanceEvaluator(AMatrix::Matrix, weights::Vector)::Matrix

Evaluate the dominance of each alternative over the others using the following formula:
``δ(i,j) = \\sum_{c=1}^{m} (A_{ik} - A_{jk})a_{rc}``.
If `δ(i,j) > 0`, then `i` dominates `j`. If `δ(i,j) < 0`, then `j` dominates `i`. If `δ(i,j) = 0`, then `i` and `j` are indifferent.

# Arguments
- `AMatrix::Matrix`: A matrix of decision criteria that is comprised of values in the range \
of 0 to 1.
- `aᵣ::Vector`: A vector of relative weights of criteria.

# Returns
- `Matrix`: A square matrix of dominance of each alternative over the others.

# Example
```julia
julia> mat = [
           1.0       0.0;
           0.666667  0.666667;
           0.555556  0.333333;
       ];

julia> w = [2, 8];

julia> w2 = criteriaWeights(w);

julia> A = AMatConstructor(mat, [maximum, minimum]);

julia> normalizedAMatrix!(A);

julia> dominanceEvaluator(A, w2)
3×3 Matrix{Float64}:
  0.0       0.885714   0.542857
 -0.885714  0.0       -0.342857
 -0.542857  0.342857   0.0
```
"""
function dominanceEvaluator(AMatrix::Matrix, aᵣ::Vector)::Matrix
    size(AMatrix, 2) == length(aᵣ) || DimensionMismatch("The number of weights must be equal to the number of columns of decision matrix.") |> throw
    n, m       = size(AMatrix)
    aDominance = zeros(Float64, n, n)
    for i in 1:n
        if i+1 > n
            break
        end
        for j in i+1:n
            aDominance[i,j] = sum((AMatrix[i,:] .- AMatrix[j,:]).*aᵣ)
        end
    end

    # Fill the lower triangular matrix
    for i in 2:n
        for j in 1:i-1
            aDominance[i,j] = -aDominance[j,i]
        end
    end
    return aDominance
end

function rankEvaluator(dominanceMatrix::Matrix)::Vector
    Ϛ          = sum(dominanceMatrix, dims=2) |> vec
    min_, max_ = extrema(Ϛ)
    return (Ϛ .- min_)/(max_-min_)
end

"""
    todim(decisionMat::Matrix, weights::Vector, fns::Array{F,1})::TODIMResult where F<:Function

Run TODIM method for a given desicion matrix, criteria weights and identity of criteria.

# Arguments
- `decisionMat::Matrix`: A matrix of decision criteria. It's assumed that the criteria are \
in the columns and alternatives are in the rows.
- `weights::Vector`: A vector of weights of criteria.
- `fns::Array{F,1}`: A vector of functions that specifies the Beneficial Criteria (BC) as \
`maximum` and the non-Beneficial Criteria (NC) as `minimum`.

# Returns
- `TODIMResult`: A TODIMResult object that holds multiple outputs including scores and best \
index.

# Example
```julia
julia> mat = [
           1.0     0.9925;
           0.8696  0.8271;
           0.7391  0.8684;
           0.5217  0.7895;
           0.6522  0.9135;
           0.6087  0.8346;
           0.913   0.185
       ];

julia> fns = [maximum, minimum];

julia> w = [2, 3];

julia> result = todim(mat, w, fns)
Scores:
[0.19354838709677424, 0.5806451612903226, 0.22580645161290328, 0.38709677419354843, 0.0, 0.22580645161290328, 1.0]
Ordering:
[7, 2, 4, 3, 6, 1, 5]
Best indice:
7
```
"""
function todim(
    decisionMat::Matrix,
    weights::Array{<:Real,1},
    fns::Array{F,1}
) where {F<:Function}

    AMatrix    = AMatConstructor(decisionMat, fns)
    normalizedAMatrix!(AMatrix)
    aᵣ         = criteriaWeights(weights)
    aDominance = dominanceEvaluator(AMatrix, aᵣ)
    scores     = rankEvaluator(aDominance)
    ranked     = sortperm(scores, rev=true)
    bestIndex  = ranked[1]
    return TODIMResult(decisionMat, weights, scores, ranked, bestIndex)
end

end # module Todim
