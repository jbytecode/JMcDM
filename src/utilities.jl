module Utilities

export I, mean, var, std 
export geomean, cor, euclidean
export normalize, apply_columns 
export colmaxs, colmins, unitize
export makeDecisionMatrix, reverseminmax, makeminmax
export rowmins, rowmaxs, rowmeans, rowsums
export colmins, colmaxs, colmeans, colsums
export makegrey

using DataFrames 

import ..GreyNumbers: GreyNumber

function I(n)
    mat = zeros(n, n)
    for i in 1:n
        mat[i, i] = 1.0
    end
    return mat
end

mean(x) = sum(x)/length(x)

function var(x) 
    e = eltype(x)
    onee = one(e)
    m = mean(x)
    xm = x .- m
    return sum((xm .* xm) ./ (length(x) * onee - onee)) 
end 

std(x) = var(x) |> sqrt

geomean(x::Array{<: Number, 1}) = exp(sum(log.(x))/length(x))

function cor(x, y)
    xmd= x .- mean(x)
    ymd =y .- mean(y)
    return (sum(xmd .* ymd) / sqrt(var(x) * var(y))) / (length(x) - one(eltype(x)))
end

function cor(x::Matrix)
    _, p = size(x)
    cormat = ones(p, p)
    for i in 1:p
        for j in i:p
            if i != j 
                cr = cor(x[:,i], x[:,j])
                cormat[i, j] = cr
                cormat[j, i] = cr
            end
        end
    end
    return cormat
end

function euclidean(v1::Vector, v2::Vector)
    (v1 .- v2).^2.0 |> sum |> sqrt
end

function euclidean(v1::Vector)
    v2 = zeros(Float64, length(v1))
    return euclidean(v1, v2)
end

function euclidean(v1::Vector, row::DataFrames.DataFrameRow{DataFrame, DataFrames.Index})
    v2 = Vector(row)
    (v1 .- v2).^2.0 |> sum |> sqrt
end

function normalize(v1::Vector)::Vector 
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


function apply_columns(fs::Array{Function,1}, data)
    _, m = size(data)
    return [fs[i](data[:,i]) for i in 1:m]
end

function apply_columns(f::Function, data)
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

function apply_rows(f::Function, data)
    return [f(c) for c in eachrow(data)]
end

function rowmins(data::DataFrame)::Vector
    return apply_rows(minimum, data)
end

function rowmaxs(data::DataFrame)::Vector
    return apply_rows(maximum, data)
end

function rowsums(data)::Vector
    return apply_rows(sum, data)
end

function rowmeans(data)::Vector
    return apply_rows(mean, data)
end

function unitize(v::Vector)::Vector 
    return v ./ sum(v)
end

function Base.:*(w::Vector, data::DataFrame)::DataFrame 
    newdf = copy(data)
    _, p = size(newdf)
    for i in 1:p
        newdf[!, i] = newdf[!,i]
        newdf[:, i] = w[i] .* data[:, i]
    end
    return newdf
end

function Base.:-(r1::DataFrameRow, r2::DataFrameRow)::Vector
    # v1 = convert(Array{Float64,1}, r1)
    v1 = Vector(r1)
    # v2 = convert(Array{Float64,1}, r2)
    v2 = Vector(r2)
    return v1 .- v2
end

#function Base.:-(r1::Array{T,1}, r2::DataFrameRow)::Array{T,1} where T <: Number
#    # v2 = convert(Array{Float64,1}, r2)
#    v2 = Vector{Float64}(r2)
#    return r1 .- v2
#end
#
#function Base.:-(r1::DataFrameRow, r2::Array{T,1})::Array{T,1} where T <: Number
#    v1 = convert(Array{Float64,1}, r1)
#    return v1 .- r2
#end

function Base.:-(r1::Vector, r2::DataFrameRow)::Vector
    # v2 = convert(Array{Float64,1}, r2)
    return r1 .- r2
end

function Base.:-(r1::DataFrameRow, r2::Vector)::Vector
    return r1 .- r2
end


"""
    makeDecisionMatrix(mat; names)

    Create a DataFrame using a decision matrix optionally using column names.

# Arguments:
 - `mat::Array{T,2}`: Matrix of numbers in any set
 - `names::Union{Nothing,Array{String,1}}`: Column names. Default is nothing. If column names are not given, they are labelled as Crt 1, Crt 2, ..., etc.
 
"""
function makeDecisionMatrix(mat::Matrix; names::Union{Nothing,Array{String,1}}=nothing)::DataFrame
    _, m = size(mat)
    df = DataFrame()
    for i in 1:m
        if names isa Nothing
            name = string("Crt", i)
        else
            name = names[i]
        end
        df[:,Symbol(name)] = mat[:, i]
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

function makegrey(m::Matrix)::Matrix 
    n, p = size(m)
    greymatrix = Array{GreyNumber, 2}(undef, n, p)
    for i in 1:n 
        for j in 1:p
            greymatrix[i, j] = GreyNumber(Float64(m[i, j]))
        end
    end 
    return greymatrix
end 

end # End of module Utilities