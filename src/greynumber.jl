module GreyNumbers

export GreyNumber
export kernel
export whitenizate
export simplify
export center 
export radius


struct GreyNumber
	a::Any
	b::Any
	GreyNumber(x, y) = new(min(x, y), max(x, y))
end

GreyNumber(a) = GreyNumber(a, a)

GreyNumber() = GreyNumber(0.0, 0.0)

function Base.:+(g1::GreyNumber, g2::GreyNumber)::GreyNumber
	return GreyNumber(g1.a + g2.a, g1.b + g2.b)
end

function Base.:+(g::GreyNumber, k)::GreyNumber
	return GreyNumber(g.a + k, g.b + k)
end

function Base.:+(k::Real, g::GreyNumber)::GreyNumber
	return g + k
end


function Base.:-(g::GreyNumber)::GreyNumber
	minusone = -1 * one(g.a)
	return GreyNumber(minusone * g.b, minusone * g.a)
end

function Base.:-(g1::GreyNumber, g2::GreyNumber)::GreyNumber
	return GreyNumber(g1.a - g2.b, g1.b - g2.a)
end

function Base.:-(g::GreyNumber, k)::GreyNumber
	return g - GreyNumber(k, k)
end

function Base.:-(k::Real, g::GreyNumber)::GreyNumber
	return GreyNumber(k, k) - g
end


function Base.:*(g1::GreyNumber, g2::GreyNumber)::GreyNumber
	v = [g1.a * g2.a, g1.a * g2.b, g1.b * g2.a, g1.b * g2.b]
	return GreyNumber(minimum(v), maximum(v))
end

function Base.:*(k, g1::GreyNumber)::GreyNumber
	a = g1.a * k
	b = g1.b * k
	return GreyNumber(min(a, b), max(a, b))
end

function Base.:*(g1::GreyNumber, k)::GreyNumber
	return k * g1
end

function Base.inv(g::GreyNumber)::GreyNumber
	newa = min(inv(g.a), inv(g.b))
	newb = max(inv(g.a), inv(g.b))
	return GreyNumber(newa, newb)
end


function Base.:/(g1::GreyNumber, g2::GreyNumber)::GreyNumber
	v = [g1.a / g2.a, g1.a / g2.b, g1.b / g2.a, g1.b / g2.b]
	v = filter(x -> !isinf(x) && !isnan(x), v)
	if length(v) < 1
		error("Cannot divide $g1 by $g2")
	end
	return GreyNumber(minimum(v), maximum(v))
end

function Base.:/(k::T, g1::GreyNumber)::GreyNumber where {T <: Real}
	return GreyNumber(k, k) / g1
end

function Base.:/(g1::GreyNumber, k::T)::GreyNumber where {T <: Real}
	return g1 / GreyNumber(k, k)
end

function Base.:^(g::GreyNumber, k::T)::GreyNumber where {T <: Real}
	@assert k > 0
	@assert g.a <= g.b
	anew = (g.a)^k
	bnew = (g.b)^k
	return GreyNumber(min(anew, bnew), max(anew, bnew))
end

function Base.log(g::GreyNumber)::GreyNumber
	return GreyNumber(log(g.a), log(g.b))
end

function Base.exp(g::GreyNumber)::GreyNumber
	return GreyNumber(exp(g.a), exp(g.b))
end



function center(g::GreyNumber)::Float64
	return (g.a + g.b) / 2.0
end

function radius(g::GreyNumber)::Float64
	return (g.b - g.a) / 2.0
end

"""
Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric 
and its application in multi-objective optimization with interval objectives." 
Computers & Industrial Engineering 74 (2014): 169-178.
"""
function Base.isless(g1::GreyNumber, g2::GreyNumber)::Bool
	return (g1 <= g2) && (g1 != g2)
end


"""
Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric 
and its application in multi-objective optimization with interval objectives." 
Computers & Industrial Engineering 74 (2014): 169-178.
"""
function Base.isless(g::GreyNumber, scalar::T)::Bool where {T <: Real}
	return g < GreyNumber(scalar, scalar)
end

"""
Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric 
and its application in multi-objective optimization with interval objectives." 
Computers & Industrial Engineering 74 (2014): 169-178.
"""
function Base.:≤(g1::GreyNumber, g2::GreyNumber)::Bool
	ac, aw = center(g1), radius(g1)
	bc, bw = center(g2), radius(g2)
	if ac != bc 
		return ac < bc
	else
		return aw <= bw
	end
end

"""
Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric 
and its application in multi-objective optimization with interval objectives." 
Computers & Industrial Engineering 74 (2014): 169-178.
"""
function Base.:>(g1::GreyNumber, g2::GreyNumber)::Bool
	return (g1 >= g2) && (g1 != g2)
end

"""
Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric 
and its application in multi-objective optimization with interval objectives." 
Computers & Industrial Engineering 74 (2014): 169-178.
"""
function Base.:≥(g1::GreyNumber, g2::GreyNumber)::Bool
	ac, aw = center(g1), radius(g1)
	bc, bw = center(g2), radius(g2)
	if ac != bc 
		return ac > bc
	else
		return aw <= bw
	end
end

function Base.isequal(g1::GreyNumber, g2::GreyNumber)::Bool
	return (g1.a == g2.a) && (g1.b == g2.b)
end

function Base.:(==)(g1::GreyNumber, g2::GreyNumber)::Bool
	return g1.a == g2.a && g1.b == g2.b
end

function Base.isreal(g::GreyNumber)::Bool
	return isreal(g.a)
end

function Base.isinteger(g::GreyNumber)::Bool
	return isinteger(g.a)
end

function Base.isinf(g::GreyNumber)::Bool
	return isinf(g.a) || isinf(g.b)
end

function Base.iszero(g::GreyNumber)::Bool
	return iszero(g.a) && iszero(g.b)
end

function Base.isone(g::GreyNumber)::Bool
	return isone(g.a) && isone(g.b)
end

function Base.iseven(g::GreyNumber)::Bool
	@assert eltype(g.a) <: Int
	return iseven(g.a) && iseven(g.b)
end

function Base.isodd(g::GreyNumber)::Bool
	@assert eltype(g.a) <: Int
	return isodd(g.a) && isodd(g.b)
end

function Base.sum(g::GreyNumber)::Real
	return g.a + g.b
end

function Base.eltype(g::GreyNumber)::Type
	return eltype(g.a)
end

function Base.eltype(::Type{GreyNumber})::Type
	return GreyNumber
end

function Base.iterate(g::GreyNumber, state = 1)
	if state == 1
		(g.a, state + 1)
	elseif state == 2
		(g.b, state + 1)
	else
		nothing
	end
end

function Base.sqrt(g::GreyNumber)::GreyNumber
	return GreyNumber(sqrt(g.a), sqrt(g.b))
end

function Base.cbrt(g::GreyNumber)::GreyNumber
	return GreyNumber(cbrt(g.a), cbrt(g.b))
end


function Base.abs(g::GreyNumber)::GreyNumber
	return GreyNumber(abs(g.a), abs(g.b))
end

function Base.abs2(g::GreyNumber)::GreyNumber
	return GreyNumber(abs2(g.a), abs2(g.b))
end

function Base.getindex(g::GreyNumber, index::Int)::Real
	@assert index == 1 || index == 2
	if index == 1
		g.a
	else
		g.b
	end
end


"""

	kernel(g::GreyNumber)::Float64

# Description

Calculate the kernel of a grey number

# Arguments

- `g::GreyNumber`: A grey number


# Examples

```julia
julia> g = GreyNumber(1, 2)
GreyNumber(1, 2)

julia> kernel(g)
1.5
```
"""
function kernel(g::GreyNumber)::Float64
	return (g.a + g.b) / 2.0
end


"""

	whitenizate(g::GreyNumber; t::Float64 = 0.5):: Float64

# Description

Whitenizate a grey number

# Arguments

- `g::GreyNumber`: A grey number
- `t::Float64`: A value between 0 and 1. Default is 0.5.

# Examples

```julia
julia> g = GreyNumber(1, 2)
GreyNumber(1, 2)

julia> whitenizate(g)
1.5
```
"""
function whitenizate(g::GreyNumber; t::Float64 = 0.5)::Float64
	@assert 0.0 <= t <= 1.0
	return g.a * t + g.b * (1.0 - t)
end


function Base.zero(::Type{GreyNumber})
	return GreyNumber(0.0, 0.0)
end



function Base.zeros(::Type{GreyNumber}, n::Int)::Array{GreyNumber, 1}
	gs = Array{GreyNumber, 1}(undef, n)
	for i ∈ 1:n
		gs[i] = GreyNumber(0.0, 0.0)
	end
	return gs
end

function Base.zeros(::Type{GreyNumber}, n::Int, m::Int)::Array{GreyNumber, 2}
	gs = Array{GreyNumber, 2}(undef, n, m)
	for i ∈ 1:n
		for j ∈ 1:m
			gs[i, j] = GreyNumber(0.0, 0.0)
		end
	end
	return gs
end

function Base.zeros(::Type{GreyNumber}, t::Tuple{Int, Int})::Array{GreyNumber, 2}
	zeros(GreyNumber, first(t), last(t))
end

function Base.one(::Type{GreyNumber})
	return GreyNumber(1.0, 1.0)
end

function Base.one(::GreyNumber)
	return GreyNumber(1.0, 1.0)
end


function Base.ones(::Type{GreyNumber}, n::Int)::Array{GreyNumber, 1}
	gs = Array{GreyNumber, 1}(undef, n)
	for i ∈ 1:n
		gs[i] = GreyNumber(1.0, 1.0)
	end
	return gs
end

function Base.ones(::Type{GreyNumber}, n::Int, m::Int)::Array{GreyNumber, 2}
	gs = Array{GreyNumber, 2}(undef, n, m)
	for i ∈ 1:n
		for j ∈ 1:m
			gs[i, j] = GreyNumber(1.0, 1.0)
		end
	end
	return gs
end

function Base.ones(::Type{GreyNumber}, t::Tuple{Int, Int})::Array{GreyNumber, 2}
	ones(GreyNumber, first(t), last(t))
end


function Base.isvalid(g::GreyNumber)::Bool
	return g.a <= g.b
end


function Base.convert(::Type{Array{T, 1}}, g::GreyNumber)::Array{T, 1} where {T}
	arr = Array{T, 1}(undef, 2)
	arr[1] = min(g.a, g.b)
	arr[2] = max(g.a, g.b)
	return arr
end

function Base.convert(::Type{GreyNumber}, num::T)::GreyNumber where {T <: Real}
	f = Float64(num)
	return GreyNumber(f, f)
end


function Base.first(g::GreyNumber)
	return g.a
end

function Base.last(g::GreyNumber)
	return g.b
end

function Base.length(g::GreyNumber)
	return 1
end

Base.broadcastable(g::GreyNumber) = Ref(g)

function Base.adjoint(g::GreyNumber)::GreyNumber
	return g
end

function Base.isapprox(x::GreyNumber, y::GreyNumber; atol)
	return isapprox(x.a, y.a, atol = atol) && isapprox(x.b, y.b, atol = atol)
end

function Base.rand(::Type{GreyNumber})::GreyNumber
	return GreyNumber(rand(Float64), rand(Float64))
end

function Base.rand(::Type{GreyNumber}, n::Integer)::Array{GreyNumber, 1}
	gs = Array{GreyNumber, 1}(undef, n)
	@inbounds for i ∈ 1:n
		gs[i] = GreyNumber(rand(Float64), rand(Float64))
	end
	return gs
end

function Base.rand(::Type{GreyNumber}, n::Integer, m::Integer)::Array{GreyNumber, 2}
	gs = Array{GreyNumber, 2}(undef, n, m)
	@inbounds for i ∈ 1:n
		@inbounds for j ∈ 1:m
			gs[i, j] = GreyNumber(rand(Float64), rand(Float64))
		end
	end
	return gs
end

function Base.isnan(g::GreyNumber)::Bool
	return isnan(g.a) || isnan(g.b)
end

function Base.isfinite(g::GreyNumber)::Bool
	return isfinite(g.a) || isfinite(g.b)
end

function simplify(n::Number)
	return n
end 

function simplify(g::GreyNumber)::Union{Number, GreyNumber}
	if g.a == g.b 
		return simplify(g.a)
	else 
		return g
	end 
end 




end # module
