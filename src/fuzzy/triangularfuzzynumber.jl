struct Triangular <: FuzzyNumber
    a::Real
    b::Real
    c::Real
    function Triangular(a, b, c)
        #@assert a <= b <= c
        new(a, b, c)
    end
end

Triangular(x) = Triangular(x, x, x)

function Triangular(x::Vector{A})::Triangular where {A<:Real}
    return Triangular(x[1], x[2], x[3])
end

function Base.:+(t1::Triangular, t2::Triangular)::Triangular
    return Triangular(t1.a + t2.a, t1.b + t2.b, t1.c + t2.c)
end

# a1 − c2 , b1 − b2 , c1 − a2
function Base.:-(t1::Triangular, t2::Triangular)::Triangular
    return Triangular(t1.a - t2.c, t1.b - t2.b, t1.c - t2.a)
end

function Base.:(==)(t1::Triangular, t2::Triangular)::Bool
    return isequal(t1, t2)
end


function Base.isequal(t1::Triangular, t2::Triangular)::Bool
    return (t1.a == t2.a) && (t1.b == t2.b) && (t1.c == t2.c)
end


function Base.:*(t1::Triangular, alpha::T) where {T<:Real}
    return Triangular(alpha * t1.a, alpha * t1.b, alpha * t1.c)
end

function Base.:*(alpha::T, t1::Triangular) where {T<:Real}
    return t1 * alpha
end

function Base.inv(t::Triangular)::Triangular
    return Triangular(inv(t.c), inv(t.b), inv(t.a))
end

function Base.:*(t1::Triangular, t2::Triangular)::Triangular
    return Triangular(t1.a * t2.a, t1.b * t2.b, t1.c * t2.c)
end

function Base.:/(t1::Triangular, t2::Triangular)::Triangular
    return Triangular(t1.a / t2.c, t1.b / t2.b, t1.c / t2.a)
end

function Base.:/(t1::Triangular, alpha::T) where {T<:Real}
    return t1 * inv(alpha)
end

function Base.:/(alpha::T, t1::Triangular) where {T<:Real}
    return alpha * inv(t1)
end

function Base.isapprox(t1::Triangular, t2::Triangular; atol::Float64)
    return (
        isapprox(t1.a, t2.a, atol = atol) &&
        isapprox(t1.b, t2.b, atol = atol) &&
        isapprox(t1.c, t2.c, atol = atol)
    )
end

function Base.length(::Type{Triangular})::Int64
    return 1
end

Base.broadcastable(t::Triangular) = Ref(t)

function Base.zero(::Type{Triangular})::Triangular
    return Triangular(0.0, 0.0, 0.0)
end

function Base.one(::Type{Triangular})::Triangular
    return Triangular(1.0, 1.0, 1.0)
end

function Base.zeros(::Type{Triangular}, n::Int64)::Vector{Triangular}
    return [zero(Triangular) for i = 1:n]
end

function Base.iterate(t::Triangular, state = 1)
    if state == 1
        (t.a, state + 1)
    elseif state == 2
        (t.b, state + 1)
    elseif state == 3
        (t.c, state + 1)
    else
        nothing
    end
end

function Base.first(t::Triangular)
    return t.a
end

function Base.last(t::Triangular)
    return t.c
end


function euclidean(t1::Triangular, t2::Triangular)::Float64
    return sqrt((1.0 / 3.0) * ((t1.a - t2.a)^2.0 + (t1.b - t2.b)^2.0 + (t1.c - t2.c)^2.0))
end


function euclidean(t1::Triangular)::Float64
    return euclidean(Triangular(0.0, 0.0, 0.0), t1)
end

function observe(t::Triangular, x::XType)::Float64 where {XType<:Real}
    if x < t.a
        return zero(eltype(x))
    elseif t.a <= x < t.b
        return (x - t.a) / (t.b - t.a)
    elseif t.b <= x < t.c
        return (t.c - x) / (t.c - t.b)
    else
        return zero(eltype(x))
    end
end

function arity(::Type{Triangular})::Int64
    return 3
end

function Base.getindex(t::Triangular, i::Int64)
    if i == 1
        return t.a
    elseif i == 2
        return t.b
    elseif i == 3
        return t.c
    else
        throw(BoundsError("Index out of bounds for Triangular: $i"))
    end
end


Base.rand(::Type{Triangular}) = Triangular(sort(rand(3))...)

Base.rand(::Type{Triangular}, i::Int64) = [Triangular(sort(rand(3))...) for _ = 1:i]

function Base.rand(::Type{Triangular}, i::Int64, j::Int64)
    m = Array{Triangular,2}(undef, i, j)
    for a = 1:i
        for b = 1:j
            m[a, b] = rand(Triangular)
        end
    end
    return m
end

# function Base.:^(t1::Triangular, t2::Triangular)::Triangular
#     @assert (0 <= t1.a <= 1) && (0 <= t1.b <= 1) && (0 <= t1.c <= 1)
#     return Triangular(t1.a^t2.c, t1.b^t2.b, t1.c^t2.a)
# end 
