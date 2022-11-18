module Utilities

export I, mean, var, std
export geomean, cor, euclidean
export normalize, apply_columns
export colmaxs, colmins, unitize
export reverseminmax
export rowmins, rowmaxs, rowmeans, rowsums
export colmins, colmaxs, colmeans, colsums
export makegrey



import ..GreyNumbers: GreyNumber

function I(n)
    mat = zeros(n, n)
    for i = 1:n
        mat[i, i] = 1.0
    end
    return mat
end

mean(x) = sum(x) / length(x)

function var(x)
    e = eltype(x)
    onee = one(e)
    m = mean(x)
    xm = x .- m
    return sum((xm .* xm) ./ (length(x) * onee - onee))
end

std(x) = var(x) |> sqrt

geomean(x::Vector) = exp(sum(log.(x)) / length(x))

function cor(x, y)
    xmd = x .- mean(x)
    ymd = y .- mean(y)
    return (sum(xmd .* ymd) / sqrt(var(x) * var(y))) / (length(x) - one(eltype(x)))
end

function cor(x::Matrix)
    _, p = size(x)
    cormat = ones(p, p)
    for i = 1:p
        for j = i:p
            if i != j
                cr = cor(x[:, i], x[:, j])
                cormat[i, j] = cr
                cormat[j, i] = cr
            end
        end
    end
    return cormat
end

function euclidean(v1::Vector, v2::Vector)
    (v1 .- v2) .^ 2.0 |> sum |> sqrt
end

function euclidean(v1::Vector)
    v2 = zeros(Float64, length(v1))
    return euclidean(v1, v2)
end


function normalize(v1::Vector)::Vector
    return v1 ./ euclidean(v1)
end

function normalize(data::Matrix)::Matrix
    df = similar(data)
    _, p = size(df)
    for i = 1:p
        df[:, i] = normalize(data[:, i])
    end
    return df
end


function apply_columns(fs::Array{F,1}, data) where {F<:Function}
    _, m = size(data)
    return [fs[i](data[:, i]) for i = 1:m]
end

function apply_columns(f::F, data) where {F<:Function}
    return [f(c) for c in eachcol(data)]
end

function colmins(data)
    return apply_columns(minimum, data)
end

function colmaxs(data)
    return apply_columns(maximum, data)
end

function colsums(data)::Array{Number,1}
    return apply_columns(sum, data)
end

function colmeans(data)::Array{Number,1}
    return apply_columns(mean, data)
end

function apply_rows(f::F, data) where {F<:Function}
    return [f(c) for c in eachrow(data)]
end

function rowmins(data)::Vector
    return apply_rows(minimum, data)
end

function rowmaxs(data)::Vector
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




function reverseminmax(fns::Array{F,1})::Array{Function,1} where {F<:Function}
    newfs = map(x -> if x == minimum
        maximum
    else
        minimum
    end, fns)
    return newfs
end


function makegrey(m::Matrix)::Matrix
    n, p = size(m)
    greymatrix = Array{GreyNumber,2}(undef, n, p)
    for i = 1:n
        for j = 1:p
            greymatrix[i, j] = GreyNumber(Float64(m[i, j]))
        end
    end
    return greymatrix
end

function weightise(mat::Matrix, w::Vector)
    newmat = similar(mat)
    _, p = size(mat)
    for i in 1:p
        newmat[:, i] = mat[:, i] .* w[i]
    end 
    return newmat
end

end # End of module Utilities
