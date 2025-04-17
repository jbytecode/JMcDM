module Fuzzy

#=
Abstract Type Definitions 
=#
abstract type FuzzyNumber end

#=
Custom Errors
=#
struct UndefinedDirectionException <: Exception 
    msg::String
end 

#=
import functions 
=#
using ..Utilities


#=
Package exports to the out of the world
=#

export UndefinedDirectionException

export FuzzyNumber, Triangular, Trapezoidal

export euclidean
export observe
export arity
export fuzzytopsis
export fuzzydecmat, prepare_weights, fuzzydecmat

export FuzzyCocosoResult
export FuzzySawResult
export FuzzyTopsisResult
export FuzzyVikorResult

export DefuzzificationMethod
export WeightedMaximum
export FirstMaximum
export LastMaximum
export MiddleMaximum
export GravityCenter
export GeometricMean
export ArithmeticMean
export defuzzification
export fuzzysaw
export fuzzycocoso
export fuzzyvikor
export fuzzyedas


#=
Inclusions
=#
include("triangularfuzzynumber.jl")
include("trapezoidalfuzzynumber.jl")
include("groupdecision.jl")
include("defuzzification.jl")
include("topsis.jl")
include("saw.jl")
include("cocoso.jl")
include("vikor.jl")
include("edas.jl")

end # End of module Fuzzy
