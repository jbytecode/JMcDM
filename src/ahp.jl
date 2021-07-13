"""
    ahp_RI(n)
Return AHP Random Index for a given n.
# Arguments:
 - `n::Int64`: Index value 
 
 # Description 
 The function returns the random index for a given integer between 3 and 15.

# Output 
- `::Float64`: Random Index (RI) value.

# Examples
```julia-repl
julia> ahp_RI(3)
0.58
```

# References

Saaty, Thomas L. "Decision making with the analytic hierarchy process." International journal of services sciences 1.1 (2008): 83-98.
```
"""
function ahp_RI(n::Int64)::Float64
    # First index is n = 3
    # RI[3] = 0.58
    # RI[4] = 0.90
    ris = [0.58, 0.90, 1.12, 1.24, 1.32,
          1.41, 1.45, 1.49, 1.51, 1.53,
          1.56, 1.57, 1.59]
    if n < 3 
        return 0
    elseif n <= 15
        return ris[n - 2]
    else
        return ris |> last
    end

end


"""
    ahp_consistency(comparisonMatrix)
    Test if a comparison matrix whether consistent or not.
 
 # Arguments:
 - `comparisonMatrix::DataFrame`: Comparison matrix for AHP. 
 
 # Description 
 AHP is based on subjective comparison between criteria. The success of the method highly depends on
 consistency of these comparison. 

# Output 
- `::AHPConsistencyResult`: AhpConsistencyResult object that holds multiple outputs including the boolean that indicates the matrix is whether consistent or not.

# Examples
```julia-repl
julia> K = [
               1 7 (1 / 5) (1 / 8) (1 / 2) (1 / 3) (1 / 5) 1;
               (1 / 7) 1 (1 / 8) (1 / 9) (1 / 4) (1 / 5) (1 / 9) (1 / 8);
               5 8 1 (1 / 3) 4 2 1 1;
               8 9 3 1 7 5 3 3;
               2 4 (1 / 4) (1 / 7) 1 (1 / 2) (1 / 5) (1 / 5);
               3 5 (1 / 2) (1 / 5) 2 1 (1 / 3) (1 / 3);
               5 9 1 (1 / 3) 5 3 1 1;
               1 8 1 (1 / 3) 5 3 1 1
           ];

julia> K
8×8 Array{Float64,2}:
 1.0       7.0  0.2    0.125     0.5   0.333333  0.2       1.0
 0.142857  1.0  0.125  0.111111  0.25  0.2       0.111111  0.125
 5.0       8.0  1.0    0.333333  4.0   2.0       1.0       1.0
 8.0       9.0  3.0    1.0       7.0   5.0       3.0       3.0
 2.0       4.0  0.25   0.142857  1.0   0.5       0.2       0.2
 3.0       5.0  0.5    0.2       2.0   1.0       0.333333  0.333333
 5.0       9.0  1.0    0.333333  5.0   3.0       1.0       1.0
 1.0       8.0  1.0    0.333333  5.0   3.0       1.0       1.0

julia> dmat = makeDecisionMatrix(K);
julia> ahp_consistency(dmat).isConsistent
true
```

# References
Saaty, Thomas L. "Decision making with the analytic hierarchy process." International journal of services sciences 1.1 (2008): 83-98.
"""
function ahp_consistency(comparisonMatrix::DataFrame)::AHPConsistencyResult
  
    n, m = size(comparisonMatrix)
  
    csums = colsums(comparisonMatrix)
    normalizedComparisonMatrix = zeros(Float64, n, n)

    for i in 1:n
        for j in 1:n
            normalizedComparisonMatrix[i, j] = comparisonMatrix[i, j] / csums[j]
        end
    end

    priority_vector = rowmeans(normalizedComparisonMatrix)
    #mcomparisonMatrix = convert(Array{Float64,2}, comparisonMatrix)
    mcomparisonMatrix = Matrix{Float64}(comparisonMatrix)

    consistency_vector = mcomparisonMatrix * priority_vector

    pc_matrix = consistency_vector ./ priority_vector

    lambda_max = sum(pc_matrix) / n

    CI  = (lambda_max - n) / (n - 1)
    ri  = ahp_RI(n)
    CR  = CI / ri

    isConsistent = (CR < 0.1)

    result = AHPConsistencyResult(
        comparisonMatrix,
        makeDecisionMatrix(normalizedComparisonMatrix),
        consistency_vector,
        priority_vector,
        pc_matrix,
        lambda_max,
        CI,
        ri,
        CR,
        isConsistent
    )

    return result

end



"""
    AHP(comparisonMatrixList, criteriaComparisonMatrix)
Apply AHP (Analytical Hierarchy Process) for a given comparison matrix and criteria comparison matrix.

# Arguments:
 - `comparisonMatrixList::Array{DataFrame,1}`: Array of comparison matrices for all of the criteria. 
 - `criteriaComparisonMatrix::DataFrame`: Criteria comparison matrix for AHP (Comparison of columns). 
 
 
 # Description 
 AHP is based on subjective comparison between criteria. The success of the method highly depends on
 consistency of these comparison. The method test the consistency first. At the next step, weights are
 calculated. The ordering of rows is determined by these weights.

# Output 
- `::AHPResult`: AhpResult object that holds multiple outputs including calculated weights and scores.

# Examples
```julia-repl
julia> K
8×8 Array{Float64,2}:
 1.0       7.0  0.2    0.125     0.5   0.333333  0.2       1.0
 0.142857  1.0  0.125  0.111111  0.25  0.2       0.111111  0.125
 5.0       8.0  1.0    0.333333  4.0   2.0       1.0       1.0
 8.0       9.0  3.0    1.0       7.0   5.0       3.0       3.0
 2.0       4.0  0.25   0.142857  1.0   0.5       0.2       0.2
 3.0       5.0  0.5    0.2       2.0   1.0       0.333333  0.333333
 5.0       9.0  1.0    0.333333  5.0   3.0       1.0       1.0
 1.0       8.0  1.0    0.333333  5.0   3.0       1.0       1.0

julia> A1
4×4 Array{Float64,2}:
 1.0       3.0  0.2       2.0
 0.333333  1.0  0.142857  0.333333
 5.0       7.0  1.0       4.0
 0.5       3.0  0.25      1.0

julia> A2
4×4 Array{Float64,2}:
 1.0   0.5       4.0       5.0
 2.0   1.0       6.0       7.0
 0.25  0.166667  1.0       3.0
 0.2   0.142857  0.333333  1.0

julia> A3
4×4 Array{Float64,2}:
 1.0       0.5  0.166667  3.0
 2.0       1.0  0.25      5.0
 6.0       4.0  1.0       9.0
 0.333333  0.2  0.111111  1.0

julia> A4
4×4 Array{Float64,2}:
 1.0       7.0  0.25      2.0
 0.142857  1.0  0.111111  0.2
 4.0       9.0  1.0       5.0
 0.5       5.0  0.2       1.0

julia> A5
4×4 Array{Float64,2}:
 1.0       6.0  2.0   3.0
 0.166667  1.0  0.25  0.333333
 0.5       4.0  1.0   2.0
 0.333333  3.0  0.5   1.0

julia> A6
4×4 Array{Float64,2}:
 1.0  0.25  0.5  0.142857
 4.0  1.0   2.0  0.333333
 2.0  0.5   1.0  0.2
 7.0  3.0   5.0  1.0

julia> A7
4×4 Array{Float64,2}:
 1.0       3.0   7.0  1.0
 0.333333  1.0   4.0  0.333333
 0.142857  0.25  1.0  0.142857
 1.0       3.0   7.0  1.0

julia> A8
4×4 Array{Float64,2}:
 1.0    2.0       5.0       8.0
 0.5    1.0       3.0       6.0
 0.2    0.333333  1.0       3.0
 0.125  0.166667  0.333333  1.0

julia> km = makeDecisionMatrix(K);
julia> as = map(makeDecisionMatrix, [A1, A2, A3, A4, A5, A6, A7, A8]);
julia> result = ahp(as, km);
julia> result.bestIndex
3
julia> result.scores
4-element Array{Float64,1}:
 0.2801050163111839
 0.14822726478768022
 0.3813036392434616
 0.19036407965767424
```

# References
Saaty, Thomas L. "Decision making with the analytic hierarchy process." International journal of services sciences 1.1 (2008): 83-98.
"""
function ahp(comparisonMatrixList::Array{DataFrame,1}, criteriaComparisonMatrix::DataFrame)::AHPResult
    
    result_list = map(ahp_consistency, comparisonMatrixList)

    n = length(result_list)

    ncriteria, _ = size(criteriaComparisonMatrix)

    ncandidates, _ = size(comparisonMatrixList[1])

    decision_matrix = zeros(Float64, ncandidates, ncriteria)

    @inbounds for i in 1:n
        decision_matrix[:,i] = result_list[i].priority
    end

    criteria_consistency = ahp_consistency(criteriaComparisonMatrix)

    weights = criteria_consistency.priority

    decision_matrix_df = makeDecisionMatrix(decision_matrix)
    ordering_result =  decision_matrix * weights
    
    bestIndex = sortperm(ordering_result) |> last

    result = AHPResult(
        comparisonMatrixList,
        criteriaComparisonMatrix,
        criteria_consistency,
        decision_matrix_df,
        ordering_result,
        weights,
        bestIndex
    )

    return result
end

