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
    mcomparisonMatrix = convert(Array{Float64,2}, comparisonMatrix)

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




function ahp(comparisonMatrixList::Array{DataFrame,1}, criteriaComparisonMatrix::DataFrame)
    
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

