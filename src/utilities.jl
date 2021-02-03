function euclidean(v1::Array{Float64,1}, v2::Array{Float64,1})::Float64 
    (v1 .- v2).^2.0 |> sum |> sqrt
end

function euclidean(v1::Array{Float64,1})::Float64
    v2 = zeros(Float64, length(v1))
    return euclidean(v1, v2)
end

function normalize(v1::Array{Float64,1})::Array{Float64,1}
    return v1 ./ euclidean(v1) 
end

function normalize(data::DataFrame)::DataFrame
    df = copy(data)
    _, p = size(df)
    for i in 1:p
        df[:, i] = normalize(data[:, i])
    end
    return df
end

function apply_columns(f::Function, data::DataFrame)
    return [f(c) for c in eachcol(data)]
end

function colmins(data::DataFrame)::Array{Float64,1}
    return apply_columns(minimum, data)
end

function colmaxs(data::DataFrame)::Array{Float64,1}
    return apply_columns(maximum, data)
end

function unitize(v::Array{Float64,1})::Array{Float64,1}
    return v ./ sum(v)
end

function Base.:*(w::Array{Float64,1}, data::DataFrame)::DataFrame
    newdf = copy(data)
    _, p = size(newdf)
    for i in 1:p
        newdf[:, i] = w[i] .* data[:, i]
    end
    return newdf
end

