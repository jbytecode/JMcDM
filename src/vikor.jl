function vikor(decisionMat::DataFrame, weights::Array{Float64,1}; v::Float64=0.5)::VikorResult
    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    col_max = colmaxs(decisionMat)
    col_min = colmins(decisionMat)

    A = similar(decisionMat)

    for i in 1:nalternatives
        for j in 1:ncriteria
            @inbounds A[i, j] = abs((col_max[j] - decisionMat[i, j]) / (col_max[j] - col_min[j]))
        end
    end

    weightedA = w * A

    s = Array{Float64,1}(undef, nalternatives)
    r = similar(s)
    q = similar(s)

    for i in 1:nalternatives
        s[i] = sum(weightedA[i,:])
        r[i] = maximum(weightedA[i,:])
    end

    smin = minimum(s)
    smax = maximum(s)
    rmin = minimum(r)
    rmax = maximum(r)
    q = v .* ((s .- smin ./ (smax .- smin))) + (1 - v) .* ((r .- rmin ./ (rmax .- rmin)))

    best_index = sortperm(q) |> first 

    result = VikorResult(
        decisionMat,
        w,
        weightedA,
        best_index,
        q
    )
    return result
end