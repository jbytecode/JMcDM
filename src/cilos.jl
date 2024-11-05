module CILOS

export cilos, CilosResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations


struct CILOSResult <: MCDMResult
    normalizedmatrix::Matrix
    highestvaluerows::Vector{Int}
    A::Matrix
    P::Matrix
    F::Matrix
    weights::Vector
end


"""
    cilos(decisionMat::Matrix, fs::Array{Function, 1}; normalization::Function = Normalizations.dividebycolumnsumnormalization)::CILOSResult

    CILOS method for MCDM problems.
    
# Arguments

- `decisionMat::Matrix`: Decision matrix in type of Matrix.
- `fs::Array{Function, 1}`: Array of functions. The elements are either minimum or maximum.
- `normalization::Function`: Normalization function. Default is dividebycolumnsumnormalization.

# Description

    CILOS is a method for MCDM problems. It is based on the concept of the ideal solution. The method
    is proposed by Zavadskas and Podvezko. The method is used to find the weights of the criteria.

# Reference

- Zavadskas, Edmundas Kazimieras, and Valentinas Podvezko. "Integrated determination of objective criteria weights in MCDM." International Journal of Information Technology & Decision Making 15.02 (2016): 267-283.
"""
function cilos(
    decisionMat::Matrix,
    fs::Array{F,1}; 
    normalization::G = Normalizations.dividebycolumnsumnormalization)::CILOSResult where {F<:Function, G<: Function}

    # n: Number of alternatives
    # m: Number of criteria
    n, m = size(decisionMat)
    

    etype = eltype(decisionMat)

    X = copy(decisionMat)
    A = zeros(etype, m, m)
    P = zeros(etype, m, m)
    
    for j in 1:m 
        if fs[j] == minimum 
            X[:, j] = minimum(X[:, j]) ./ X[:, j]
        end
    end 

    normalizedmatrix = normalization(X, [maximum for _ in 1:m])

    highestvaluerows = [argmax(normalizedmatrix[:, j]) for j in 1:m]
    columnmax = [maximum(normalizedmatrix[:, j]) for j in 1:m]

    for i in 1:n  
        A[i, :] = normalizedmatrix[highestvaluerows[i], :]
    end 

    for i in 1:m
        for j in 1:m
            P[i, j] = (columnmax[j] - A[i, j]) / columnmax[j]
        end
    end 

    Fm = copy(P)
    for i in 1:m 
        Fm[i, i] = -sum(P[:, i])
    end 

    # Systems of linear equations 
    # [.. .. .. | 0]
    # [.. .. .. | 0]
    # [1 1 1 1  | 1]
    Xmat = vcat(Fm, ones(etype, m)')
    yvec = vcat(zeros(etype, m), 1.0)
    W = Xmat \ yvec

    return CILOSResult(normalizedmatrix, highestvaluerows, A, P, Fm,  W)
end 

end # module CILOS