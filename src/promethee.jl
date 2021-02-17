function prometLinear(d::Number, q::Number, p::Number)::Float64
    if (d <= q)
        0
    elseif (q < d <= p)
        (d - q) / (p - q)
    else
        1
    end
end

function prometVShape(d::Number, q::Any, p::Number)::Float64
    if (d <= 0)
        0
    elseif (0 < d <= p)
        d / p
    else
        1
    end
end

function prometUsual(d::Number, q::Any, p::Any)::Float64
    if (d == 0)
        0
    else
        1
    end
end

function prometUsual(d::Number, q::Any, p::Any)::Float64
    if (d == 0)
        0
    else
        1
    end
end

function prometQuasi(d::Number, q::Number, p::Any)::Float64
    if (d <= q)
        0
    else
        1
    end
end

function prometLevel(d::Number, q::Number, p::Number)::Float64
    if (d <= q)
        0
    elseif (0 < d <= p)
        1 / 2
    else
       1
    end
end

function promethee(decisionMatrix::DataFrame, prefs::Array{Function,1}, weights::Array{Float64,1}, fns::Array{Function,1}, qs::Array, ps::Array)::PrometheeResult

    actionCount, criteriaCount = size(decisionMatrix)

    dValues = zeros(Float64, criteriaCount, actionCount, actionCount)

    for c in 1:criteriaCount, i in 1:actionCount, j in 1:actionCount
        dValues[c,i,j] = fns[c]([-1, 1]) * (decisionMatrix[i,c] - decisionMatrix[j,c])
    end

    pValues = zeros(Float64, criteriaCount, actionCount, actionCount)

    for c in 1:criteriaCount, i in 1:actionCount, j in 1:actionCount
        pValues[c,i,j] = prefs[c](dValues[c,i,j], qs[c], ps[c])
    end

    pValues .*= weights
    
    flows = sum(pValues, dims=1)[1,:,:]

    negSum = sum(flows, dims=1)[1,:] / (actionCount - 1)
    posSum = sum(flows, dims=2)[:,1] / (actionCount - 1)

    scores = negSum - posSum

    rankings = scores |> sortperm
    
    bestIndex = rankings |> first

    return PrometheeResult(decisionMatrix, weights, scores, rankings, bestIndex)

end