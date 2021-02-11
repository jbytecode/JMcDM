function grey(decisionMat::DataFrame, weights::Array{Float64,1}; fs::Array{Function,1}, zeta::Float64=0.5)::GreyResult

    mat = convert(Matrix, decisionMat)

    nrows, ncols = size(mat)

    w = unitize(weights)

    referenceRow = apply_columns(fs, mat)

    normalizedReferenceRow = zeros(Float64, ncols)

    normalizedMat = copy(mat)
    for col in 1:ncols
        mmax = maximum(mat[:, col])
        mmin = minimum(mat[:, col])
        mrange = mmax - mmin
        for row in 1:nrows
            if fs[col] == maximum 
                normalizedMat[row, col] = (mat[row, col] - mmin) / mrange
            elseif fs[col] == minimum 
                normalizedMat[row, col] = (mmax - mat[row, col]) / mrange
            else
                @error fs[col]
                error("Function not defined")
            end
        end
        if fs[col] == maximum
            normalizedReferenceRow[col] = (referenceRow[col] - mmin) / mrange
        elseif fs[col] == minimum 
            normalizedReferenceRow[col] = (mmax - referenceRow[col]) / mrange
        end
    end

    absoluteValueMat = copy(mat)
    for row in 1:nrows
        absoluteValueMat[row,:] = normalizedReferenceRow .- normalizedMat[row, :]  .|> abs 
    end

    deltamin = absoluteValueMat |> minimum
    deltamax = absoluteValueMat |> maximum
    zetadeltamax = zeta * deltamax

    greytable = copy(absoluteValueMat)
    for row in 1:nrows
        for col in 1:ncols
            greytable[row, col] = (deltamin + zetadeltamax) / (absoluteValueMat[row, col] + zetadeltamax) 
        end
    end

    weightedsums = zeros(Float64, nrows)
    for i in 1:nrows
        weightedsums[i] = w .* greytable[i, :] |> sum 
    end

    orderings = sortperm(weightedsums)
    bestIndex = orderings |> last

    result = GreyResult(
        referenceRow,
        normalizedMat,
        absoluteValueMat,
        greytable,
        weightedsums,
        orderings,
        bestIndex
    )
    
    return result
end