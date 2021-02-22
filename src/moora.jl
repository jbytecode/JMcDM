function moora(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})

    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    normalizedMat = normalize(decisionMat)
    weightednormalizedMat = w * normalizedMat

    # cmaxs = colmaxs(weightednormalizedMat)
    cmaxs = apply_columns(fns, weightednormalizedMat)
    cmins = apply_columns(reverseminmax(fns), weightednormalizedMat)

    refmat = similar(weightednormalizedMat)
    
    for rowind in 1:nalternatives
        if fns[rowind] == maximum 
            refmat[rowind, :] .= cmaxs - weightednormalizedMat[rowind, :]
        elseif fns[rowind] == minimum
            refmat[rowind, :] .= weightednormalizedMat[rowind, :] - cmins
        else
            @warn fns[rowind]
            error("Function must be either maximize or minimize")
        end
    end

    scores = rmaxs = rowmaxs(refmat)

    bestIndex = sortperm(rmaxs) |> first 

    result = MooraResult(
       decisionMat,
       w,
       weightednormalizedMat,
       refmat,
       scores,
       bestIndex
   )

    return result
end