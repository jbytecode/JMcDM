function aras(decisionMat::DataFrame, weights::Array{Float64,1}, fs::Array{Function,1})::ARASResult

    mat = convert(Matrix, decisionMat)
    nrows, ncols = size(mat)
    w = unitize(weights)
    referenceRow = apply_columns(fs, mat)
    extendMat = [mat; referenceRow']

    for col in 1:ncols
        if fs[col] == minimum
            extendMat[:, col] = 1 ./ extendMat[:, col]
        end
    end

    normalizedMat = copy(extendMat)

    for col in 1:ncols
        for row in 1:nrows+1
            normalizedMat[row, col] = extendMat[row, col] ./ sum(extendMat[:, col])
        end
    end

    optimality = copy(normalizedMat)

    optimality_degrees = zeros(Float64, nrows+1)
    for i in 1:nrows+1
        optimality_degrees[i] = w .* optimality[i, :] |> sum 
    end

    utility_degrees = zeros(Float64, nrows)
    for i in 1:nrows
        utility_degrees[i] = optimality_degrees[i] /  optimality_degrees[end]
    end

    orderings = sortperm(utility_degrees)
    bestIndex = orderings |> last

    result = ARASResult(
        referenceRow,
        extendMat,
        normalizedMat,
        optimality_degrees,
        utility_degrees,
        orderings,
        bestIndex
    )
    
    return result
end