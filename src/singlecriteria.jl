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

