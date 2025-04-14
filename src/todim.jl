module TODIM
import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

export TODIMMethod, TODIMResult, todim

struct TODIMMethod <: MCDMMethod end

struct TODIMResult <: MCDMResult
    decisionMatrix::Matrix
    AMatrix::Matrix
    NormalizedAMatrix::Matrix
    weights::Array{Float64,1}
    criteriaWeights::Array{Float64,1}
    dominanceMatrix::Matrix
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end

"""
    AMatConstructor(decisionMat::Matrix, fns::Array{F,1})::Matrix where {F<:Function}

Construct the A matrix for TODIM method.
A matrix is a matrix of decision criteria that is comprised of values in the range of 1 to 
10. `AMatConstructor` assigns a score of 10 to an alternative if the corresponding value of 
alternative is among the top 10% of the values of that criterion and assigns a score of 9 
to an alternative if the corresponding value of alternative is among the top [80% 90%) of 
the values of that criterion and so on.

# Arguments
- `decisionMat::Matrix`: A matrix of decision criteria. It's assumed that the criteria are
  in the columns and alternatives are in the rows.
- `fns::Array{F,1}`: A vector of functions that specifies the Beneficial Criteria (BC) as 
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
7x2 Matrix{Float64}:
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
    return weights
end

"""
    dominanceEvaluator(AMatrix::Matrix, weights::Vector)::Matrix

Evaluate the dominance of each alternative over the others using the following formula:
``δ(i,j) = \\sum_{c=1}^{m} (A_{ik} - A_{jk})a_{rc}``.
If `δ(i,j) > 0`, then `i` dominates `j`. If `δ(i,j) < 0`, then `j` dominates `i`. If `δ(i,j) = 0`, then `i` and `j` are indifferent.

# Arguments
- `AMatrix::Matrix`: A matrix of decision criteria that is comprised of values in the range 
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

julia> using JMcDM.Normalizations

julia> A = Normalizations.maxminrangenormalization(A, [maximum, minimum]);

julia> dominanceEvaluator(A, w2)
3x3 Matrix{Float64}:
  0.0       -0.714286  -0.142857
  0.714286   0.0        0.571429
  0.142857  -0.571429   0.0
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
- `decisionMat::Matrix`: A matrix of decision criteria. It's assumed that the criteria are 
in the columns and alternatives are in the rows.
- `weights::Vector`: A vector of weights of criteria.
- `fns::Array{F,1}`: A vector of functions that specifies the Beneficial Criteria (BC) as 
`maximum` and the non-Beneficial Criteria (NC) as `minimum`.

## Keyword Arguments
- `normalization{<:Function}`: Optional normalization function. Default is min-max 
  normalization (available as `Normalizations.maxminrangenormalization`).

# Returns
- `TODIMResult`: A TODIMResult object that holds multiple outputs including scores and best 
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
TODIMResult([1.0 0.9925; 0.8696 0.8271; … ; 0.6087 0.8346; 0.913 0.185], [2.0, 3.0], [1.0, 0.4285714285714285, 0.5952380952380951, 0.0, 0.5714285714285714, 0.30952380952380953, 0.3095238095238094], [1, 3, 5, 2, 6, 7, 4], 1)
```

# References
1. Gomes, L. F. A. M., & Lima, M. M. P. P. (1991). TODIMI: Basics and application to multicriteria ranking. Found. Comput. Decis. Sci, 16(3-4), 1-16.

2. Alali, F., & Tolga, A. C. (2019). Portfolio allocation with the TODIM method. Expert Systems with Applications, 124, 341-348.
"""
function todim(
    decisionMat::Matrix,
    weights::Array{<:Real,1},
    fns::Array{F,1};
    normalization::G = Normalizations.maxminrangenormalization
) where {F<:Function, G<:Function}

    AMatrix    = AMatConstructor(decisionMat, fns)
    ANorm      = normalization(AMatrix, fns)
    aᵣ         = criteriaWeights(weights)
    aDominance = dominanceEvaluator(ANorm, aᵣ)
    scores     = rankEvaluator(aDominance)
    ranked     = sortperm(scores, rev=true)
    bestIndex  = ranked[1]
    return TODIMResult(
        decisionMat, 
        AMatrix,
        ANorm,
        weights, 
        aᵣ,
        aDominance,
        scores, 
        ranked, 
        bestIndex)
end

end # module Todim
