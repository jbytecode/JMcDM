"""
References: 

Piasecki, K., Roszkowska, E., & Łyczkowska-Hanćkowiak, A. (2019). Simple 
additive weighting method equipped with fuzzy ranking of evaluated 
alternatives. Symmetry, 11(4), 482.
"""
abstract type DefuzzificationMethod end

struct WeightedMaximum <: DefuzzificationMethod
    lambda::Float64
end

struct FirstMaximum <: DefuzzificationMethod end

struct LastMaximum <: DefuzzificationMethod end

struct MiddleMaximum <: DefuzzificationMethod end

struct GravityCenter <: DefuzzificationMethod end

struct GeometricMean <: DefuzzificationMethod end

struct ArithmeticMean <: DefuzzificationMethod end

#=
	Convert Triangular(a,b,c) to Trapezoidal(a, b, b, c)
	and continue with the methods implemented for Trapezoidal
=#
function defuzzification(t::Triangular, method::T) where {T<:DefuzzificationMethod}
    defuzzification(Trapezoidal(t.a, t.b, t.b, t.c), method)
end


function defuzzification(t::Trapezoidal, method::WeightedMaximum)
    @assert 0 <= method.lambda <= 1
    return method.lambda * t.b + (1.0 - method.lambda) * t.c
end

function defuzzification(t::Trapezoidal, method::FirstMaximum)
    return t.b
end

function defuzzification(t::Trapezoidal, method::LastMaximum)
    return t.c
end

function defuzzification(t::Trapezoidal, method::MiddleMaximum)
    return 0.5 * (t.b + t.c)
end

function defuzzification(t::Trapezoidal, method::GravityCenter)
    if t.a == t.d
        return t.a
    else
        nom = t.a^2 + t.a * t.b + t.b^2 - t.c^2 - t.c * t.d - t.d^2
        denom = 3.0 * (t.a + t.b - t.c - t.d)
        return nom / denom
    end
end

function defuzzification(t::Trapezoidal, method::GeometricMean)
    if t.a == t.d
        return t.a
    else
        nom = (t.a * t.b) - (t.c * t.d)
        denom = t.a + t.b - t.c - t.d
        return nom / denom
    end
end


function defuzzification(t::Triangular, method::ArithmeticMean)
    return  (t.a + t.b + t.c ) / 3.0
end