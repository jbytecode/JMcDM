function moora(decisionMat::DataFrame, weights::Array{Float64,1})

    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    normalizedMat = normalize(decisionMat)
    weightednormalizedMat = w * normalizedMat

    cmaxs = colmaxs(weightednormalizedMat)

    refmat = copy(weightednormalizedMat)
    
    for rowind in 1:nalternatives
        refmat[rowind, :] .= cmaxs - weightednormalizedMat[rowind, :]
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