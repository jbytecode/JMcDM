function summarizecolumn(v::Vector{FuzzyType})::FuzzyType where {FuzzyType<:FuzzyNumber}
    p = arity(FuzzyType)
    vals = zeros(Float64, p)
    vals[1] = map(fnum -> fnum[1], v) |> minimum
    vals[p] = map(fnum -> fnum[p], v) |> maximum
    for i = 2:(p-1)
        vals[i] = map(fnum -> fnum[i], v) |> mean
    end

    return FuzzyType(vals)
end

function prepare_weights(
    weightlist::Vector{Vector{FuzzyType}},
)::Vector{FuzzyType} where {FuzzyType<:FuzzyNumber}
    wmat = mapreduce(permutedims, vcat, weightlist)

    _, p = size(wmat)
    wresult = Array{FuzzyType,1}(undef, p)
    for i = 1:p
        wresult[i] = summarizecolumn(wmat[:, i])
    end
    return wresult
end


function fuzzydecmat(
    decmatlist::Vector{Matrix{FuzzyType}},
)::Matrix{FuzzyType} where {FuzzyType<:FuzzyNumber}
    n, p = size(decmatlist[1])
    newdecmat = similar(decmatlist[1])
    for i = 1:n
        for j = 1:p
            v = map(x -> x[i, j], decmatlist)
            newdecmat[i, j] = summarizecolumn(v)
        end
    end
    return newdecmat
end
