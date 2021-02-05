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