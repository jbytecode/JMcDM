function laplace(decisionMatrix::DataFrame)::LaplaceResult

    n, p = size(decisionMatrix)

    probs = [1.0 / p for i in 1:p]

    expecteds = zeros(Float64, n)

    m = convert(Array{Float64,2}, decisionMatrix)

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




function maximin(decisionMatrix::DataFrame)::MaximinResult

    n, p = size(decisionMatrix)

    m = convert(Array{Float64,2}, decisionMatrix)

    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> last

    result = MaximinResult(
        rmins,
        bestIndex
    )

    return result
end



function maximax(decisionMatrix::DataFrame)::MaximaxResult

    n, p = size(decisionMatrix)

    m = convert(Array{Float64,2}, decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> last

    result = MaximaxResult(
        rmaxs,
        bestIndex
    )

    return result
end



function minimax(decisionMatrix::DataFrame)::MinimaxResult

    n, p = size(decisionMatrix)

    m = convert(Array{Float64,2}, decisionMatrix)

    rmaxs = rowmaxs(decisionMatrix)

    bestIndex = sortperm(rmaxs) |> first

    result = MinimaxResult(
        rmaxs,
        bestIndex
    )

    return result
end




function minimin(decisionMatrix::DataFrame)::MiniminResult

    n, p = size(decisionMatrix)

    m = convert(Array{Float64,2}, decisionMatrix)

    rmins = rowmins(decisionMatrix)

    bestIndex = sortperm(rmins) |> first

    result = MiniminResult(
        rmins,
        bestIndex
    )

    return result
end



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






