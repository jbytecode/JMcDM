struct Trapezoidal <: FuzzyNumber
    a::Real
    b::Real
    c::Real
    d::Real
    function Trapezoidal(a, b, c, d)
        #@assert a <= b <= c <= d
        new(a, b, c, d)
    end
end

Trapezoidal(x) = Trapezoidal(x, x, x, x)

function Trapezoidal(x::Vector{A})::Trapezoidal where {A<:Real}
    return Trapezoidal(x[1], x[2], x[3], x[4])
end


function Base.:+(t1::Trapezoidal, t2::Trapezoidal)::Trapezoidal
    return Trapezoidal(t1.a + t2.a, t1.b + t2.b, t1.c + t2.c, t1.d + t2.d)
end

#(a1 − d2 , b1 − c2 , c1 − b2 , d1 − a2 )
function Base.:-(t1::Trapezoidal, t2::Trapezoidal)::Trapezoidal
    return Trapezoidal(t1.a - t2.d, t1.b - t2.c, t1.c - t2.b, t1.d - t2.a)
end


function Base.:(==)(t1::Trapezoidal, t2::Trapezoidal)::Bool
    return isequal(t1, t2)
end


function Base.isequal(t1::Trapezoidal, t2::Trapezoidal)::Bool
    return (t1.a == t2.a) && (t1.b == t2.b) && (t1.c == t2.c) && (t1.d == t2.d)
end


function Base.:*(t1::Trapezoidal, alpha::T) where {T<:Real}
    return Trapezoidal(alpha * t1.a, alpha * t1.b, alpha * t1.c, alpha * t1.d)
end

function Base.:*(alpha::T, t1::Trapezoidal) where {T<:Real}
    return t1 * alpha
end

function Base.inv(t::Trapezoidal)::Trapezoidal
    return Trapezoidal(inv(t.d), inv(t.c), inv(t.b), inv(t.a))
end


function Base.:*(t1::Trapezoidal, t2::Trapezoidal)::Trapezoidal
    return Trapezoidal(t1.a * t2.a, t1.b * t2.b, t1.c * t2.c, t1.d * t2.d)
end


function Base.:/(t1::Trapezoidal, t2::Trapezoidal)::Trapezoidal
    return Trapezoidal(t1.a / t2.d, t1.b / t2.c, t1.c / t2.b, t1.d / t2.a)
end


function Base.:/(t1::Trapezoidal, alpha::T) where {T<:Real}
    return t1 * inv(alpha)
end

function Base.:/(alpha::T, t1::Trapezoidal) where {T<:Real}
    return alpha * inv(t1)
end

function Base.isapprox(t1::Trapezoidal, t2::Trapezoidal; atol::Float64)
    return (
        isapprox(t1.a, t2.a, atol = atol) &&
        isapprox(t1.b, t2.b, atol = atol) &&
        isapprox(t1.c, t2.c, atol = atol) &&
        isapprox(t1.d, t2.d, atol = atol)
    )
end

function Base.length(::Type{Trapezoidal})::Int64
    return 1
end

Base.broadcastable(t::Trapezoidal) = Ref(t)

function Base.zero(::Type{Trapezoidal})::Trapezoidal
    return Trapezoidal(0.0, 0.0, 0.0, 0.0)
end

function Base.one(::Type{Trapezoidal})::Trapezoidal
    return Trapezoidal(1.0, 1.0, 1.0, 1.0)
end

function Base.zeros(::Type{Trapezoidal}, n::Int64)::Vector{Trapezoidal}
    return [zero(Trapezoidal) for i = 1:n]
end


function Base.iterate(t::Trapezoidal, state = 1)
    if state == 1
        (t.a, state + 1)
    elseif state == 2
        (t.b, state + 1)
    elseif state == 3
        (t.c, state + 1)
    elseif state == 4
        (t.d, state + 1)
    else
        nothing
    end
end

function Base.first(t::Trapezoidal)
    return t.a
end

function Base.last(t::Trapezoidal)
    return t.d
end

function euclidean(t1::Trapezoidal, t2::Trapezoidal)::Float64
    return sqrt(
        (1.0 / 4.0) *
        ((t1.a - t2.a)^2.0 + (t1.b - t2.b)^2.0 + (t1.c - t2.c)^2.0 + (t1.d - t2.d)^2.0),
    )
end

function euclidean(t1::Trapezoidal)::Float64
    origin = Trapezoidal(0.0, 0.0, 0.0, 0.0)
    return euclidean(origin, t1)
end


function observe(t::Trapezoidal, x::XType)::Float64 where {XType<:Real}
    if x < t.a
        return zero(eltype(x))
    elseif t.a <= x < t.b
        return (x - t.a) / (t.b - t.a)
    elseif t.b <= x < t.c
        return one(eltype(x))
    elseif t.c <= x < t.d
        return (t.d - x) / (t.d - t.c)
    else
        return zero(eltype(x))
    end
end

function arity(::Type{Trapezoidal})::Int64
    return 4
end

function Base.getindex(t::Trapezoidal, i::Int64)
    if i == 1
        return t.a
    elseif i == 2
        return t.b
    elseif i == 3
        return t.c
    elseif i == 4
        return t.d
    else
        throw(BoundsError("Index out of bounds for Trapezoidal : $i"))
    end
end


Base.rand(::Type{Trapezoidal}) = Trapezoidal(sort(rand(4))...)

Base.rand(::Type{Trapezoidal}, i::Int64) = [Trapezoidal(sort(rand(4))...) for _ = 1:i]

function Base.rand(::Type{Trapezoidal}, i::Int64, j::Int64)
    m = Array{Trapezoidal,2}(undef, i, j)
    for a = 1:i
        for b = 1:j
            m[a, b] = rand(Trapezoidal)
        end
    end
    return m
end
