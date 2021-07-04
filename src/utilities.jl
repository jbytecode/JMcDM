function euclidean(v1::Array{T1,1}, v2::Array{T2,1})::Float64 where {T1 <: Number,T2 <: Number} 
    (v1 .- v2).^2.0 |> sum |> sqrt
end

function euclidean(v1::Array{T,1})::Float64 where T <: Number
    v2 = zeros(Float64, length(v1))
    return euclidean(v1, v2)
end

function normalize(v1::Array{T,1})::Array{Float64,1} where T <: Number
    return v1 ./ euclidean(v1) 
end

function normalize(data::DataFrame)::DataFrame
    df = similar(data)
    _, p = size(df)
    for i in 1:p
        df[:, i] = normalize(data[:, i])
    end
    return df
end

function apply_columns(fs::Array{Function,1}, data::Union{DataFrame,Array{T,2}} where T <: Number)
    _, m = size(data)
    return [fs[i](data[:,i]) for i in 1:m]
end

function apply_columns(f::Function, data::Union{DataFrame,Array{T,2}} where T <: Number)
    return [f(c) for c in eachcol(data)]
end

function colmins(data::DataFrame) 
    return apply_columns(minimum, data)
end

function colmaxs(data::DataFrame)
    return apply_columns(maximum, data)
end

function colsums(data)::Array{Number,1} 
    return apply_columns(sum, data)
end

function colmeans(data)::Array{Number,1}
    return apply_columns(mean, data)
end

function apply_rows(f::Function, data::Union{DataFrame,Array{T,2}} where T <: Number)
    return [f(c) for c in eachrow(data)]
end

function rowmins(data::DataFrame)::Array{Float64,1}
    return apply_rows(minimum, data)
end

function rowmaxs(data::DataFrame)::Array{Float64,1}
    return apply_rows(maximum, data)
end

function rowsums(data)::Array{Float64,1}
    return apply_rows(sum, data)
end

function rowmeans(data)::Array{Float64,1}
    return apply_rows(mean, data)
end

function unitize(v::Array{T,1})::Array{Float64,1} where {T <: Number}
    return v ./ sum(v)
end

function Base.:*(w::Array{Float64,1}, data::DataFrame)::DataFrame 
    newdf = copy(data)
    _, p = size(newdf)
    for i in 1:p
        newdf[!, i] = convert.(Float64, newdf[!,i])
        newdf[:, i] = w[i] .* data[:, i]
    end
    return newdf
end

function Base.:-(r1::DataFrameRow, r2::DataFrameRow)::Array{Number,1}
    # v1 = convert(Array{Float64,1}, r1)
    v1 = Vector{Float64}(r1)
    # v2 = convert(Array{Float64,1}, r2)
    v2 = Vector{Float64}(r2)
    return v1 .- v2
end

function Base.:-(r1::Array{T,1}, r2::DataFrameRow)::Array{T,1} where T <: Number
    # v2 = convert(Array{Float64,1}, r2)
    v2 = Vector{Float64}(r2)
    return r1 .- v2
end

function Base.:-(r1::DataFrameRow, r2::Array{T,1})::Array{T,1} where T <: Number
    v1 = convert(Array{Float64,1}, r1)
    return v1 .- r2
end

"""
    makeDecisionMatrix(mat; names)

    Create a DataFrame using a decision matrix optionally using column names.

# Arguments:
 - `mat::Array{T,2}`: Matrix of numbers in any set
 - `names::Union{Nothing,Array{String,1}}`: Column names. Default is nothing. If column names are not given, they are labelled as Crt 1, Crt 2, ..., etc.
 
"""
function makeDecisionMatrix(mat::Array{T,2}; names::Union{Nothing,Array{String,1}}=nothing)::DataFrame where {T <: Number}
    _, m = size(mat)
    df = DataFrame()
    for i in 1:m
        if names isa Nothing
            name = string("Crt", i)
        else
            name = names[i]
        end
        df[:,Symbol(name)] = convert(Array{Float64,1}, mat[:, i])     
    end
    return df
end

function Base.minimum(df::DataFrame)
    df |> Matrix |> minimum
end

function reverseminmax(fns::Array{Function,1})::Array{Function,1}
    newfs = map(x -> if x == minimum maximum else minimum end, fns)
    return newfs
end

function makeminmax(fns::Array{K,1} where K)::Array{Function,1}
    return convert(Array{Function,1}, fns)
end