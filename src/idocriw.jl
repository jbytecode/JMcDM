module IDOCRIW


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations
import ..CILOS: cilos 
import ..Entropy: entropy

struct IDOCRIWResult <: MCDMResult
    entropy_weight::Vector
    cilos_weight::Vector
    weights::Vector
end


"""
    idocriw(decisionMat::Matrix, fs::Array{F,1}; normalization::G = Normalizations.dividebycolumnsumnormalization) where {F<:Function, G<: Function}

Computes the IDOCRIW method for the given decision matrix and the set of functions.

# Description

The IDOCRIW method is a MCDM method that combines the entropy and CILOS methods. The method is proposed by Zavadskas and Podvezko.
IDOCRIW is short for Integrated Determination of Objective Criteria Weights. 
The method is based on the idea that the weights of the criteria should be determined by considering the entropy and CILOS methods together.

# Arguments

- `decisionMat::Matrix`: The decision matrix in type of Matrix.
- `fs::Array{F,1}`: Array of functions. The elements are either minimum or maximum.

# Optional Arguments

- `normalization::G = Normalizations.dividebycolumnsumnormalization`: The normalization method to be used. Default is dividebycolumnsumnormalization.

# Returns

- An IDOCRIWResult object.

# Examples

```julia-repl
julia> decmat = Float64[
    3 100 10 7;
    2.5 80 8 5;
    1.8 50 20 11;
    2.2 70 12 9
]

julia> dirs = [minimum, maximum, minimum, maximum]

julia> result = idocriw(decmat, dirs)

julia> result.weights
```
"""
function idocriw(
    decisionMat::Matrix,
    fs::Array{F,1}; 
    normalization::G = Normalizations.dividebycolumnsumnormalization)::IDOCRIWResult where {F<:Function, G<: Function}

    entropy_result = entropy(decisionMat)
    entropy_weight = entropy_result.w

    cilos_result = cilos(decisionMat, fs; normalization = normalization)
    cilos_weight = cilos_result.weights

    qw = entropy_weight .* cilos_weight
    qws = sum(qw)

    weights = qw ./ qws

    return IDOCRIWResult(entropy_weight, cilos_weight, weights)
end 

end # End of module IDOCRIW