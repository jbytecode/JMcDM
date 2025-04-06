module Normalizations 

import ..Utilities: normalize, colmins, colmaxs

"""
    nullnormalization(data::Matrix, fns)::Matrix

Default normalization method for disabling normalization
"""
function nullnormalization(data::Matrix, fns)::Matrix 
    return data
end


"""
    vectornormnormalization(data::Matrix, fns)::Matrix

Default normalization method for Topsis and Moora 
"""
function vectornormnormalization(data::Matrix, fns)::Matrix
    return normalize(data)
end



"""
    dividebycolumnsumnormalization(data::Matrix, fns)::Matrix

Default normalization method for Aras and Copras
"""
function dividebycolumnsumnormalization(data::Matrix, fns)::Matrix 
    normalizedMat = similar(data)

    nrows, ncols = size(data)

    for col = 1:ncols
        for row = 1:nrows
            normalizedMat[row, col] = data[row, col] ./ sum(data[:, col])
        end
    end

    return normalizedMat
end



"""
    maxminrangenormalization(data::Matrix, fns)::Matrix

Default normalization method for Cocoso, Critic, Grey, Mabac, and Mairca
"""
function maxminrangenormalization(data::Matrix, fns)::Matrix 
    A = similar(data)

    row, col = size(data)
    colMax = colmaxs(data)
    colMin = colmins(data)

    for i = 1:row
        for j = 1:col
            if fns[j] == maximum
                @inbounds A[i, j] =
                    (data[i, j] - colMin[j]) / (colMax[j] - colMin[j])
            elseif fns[j] == minimum
                @inbounds A[i, j] =
                    (colMax[j] - data[i, j]) / (colMax[j] - colMin[j])
            end
        end
    end

    return A
end 


"""
    inversemaxminrangenormalization(data::Matrix, fns)::Matrix

"""
function inversemaxminrangenormalization(data::Matrix, fns)::Matrix 
    A = similar(data)

    row, col = size(data)
    colMax = colmaxs(data)
    colMin = colmins(data)

    for i = 1:row
        for j = 1:col
            if fns[j] == minimum
                @inbounds A[i, j] =
                    (data[i, j] - colMin[j]) / (colMax[j] - colMin[j])
            elseif fns[j] == maximum
                @inbounds A[i, j] =
                    (colMax[j] - data[i, j]) / (colMax[j] - colMin[j])
            end
        end
    end

    return A
end 

"""
    dividebycolumnmaxminnormalization(mat::Matrix, fns)

Default normalization method for Codas and Psi.
"""
function dividebycolumnmaxminnormalization(mat::Matrix, fns)
    
    nrows, ncols = size(mat)
    
    colMax = colmaxs(mat)
    colMin = colmins(mat)

    A = similar(mat)

    for i = 1:ncols
        if fns[i] == maximum
            @inbounds A[:, i] = mat[:, i] ./ colMax[i]
        elseif fns[i] == minimum
            @inbounds A[:, i] = colMin[i] ./ mat[:, i]
        end
    end

    return A 
end 


"""
    groupeddividebymaxminnormalization(mat::Matrix, fns)

    Default normalization method for seca.
"""
function groupeddividebymaxminnormalization(mat::Matrix, fns)
    Amat = similar(mat)

    max_idx, min_idx = fns .== maximum, fns .== minimum
    
    # Normalize the decision matrix based on the concept of BC and NC

    if !all(iszero, max_idx)
        Amat[:, max_idx] .= mat[:, max_idx] ./ maximum(mat[:, max_idx])
    end

    if !all(iszero, min_idx)
        Amat[:, min_idx] .= minimum(mat[:, min_idx]) ./ mat[:, min_idx]
    end

    return Amat
end 


"""
    inversedividebycolumnmaxminnormalization(mat::Matrix, fns)

Default normalization method by Merec.
"""
function inversedividebycolumnmaxminnormalization(mat::Matrix, fns)
    NormalizeMatrix = similar(mat)
    row, col = size(mat)
    @inbounds for i = 1:row
        for j = 1:col
            if fns[j] == maximum
                NormalizeMatrix[i, j] = minimum(mat[:, j]) / mat[i, j]
            elseif fns[j] == minimum
                NormalizeMatrix[i, j] = mat[i, j] / maximum(mat[:, j])
            end
        end
    end
    return NormalizeMatrix
end 



"""
    dividebyallnormnormalization(mat::Matrix, fns)

Default normalization method for Moosra
"""
function dividebyallnormnormalization(mat::Matrix, fns)
    return mat ./ sqrt(sum(mat .* mat))
end 


"""
    marcosnormalization(decisionMat::Matrix, fns)

Default normalization method for Marcos
"""
function marcosnormalization(decisionMat::Matrix, fns)

    row, col = size(decisionMat)

    zerotype = eltype(decisionMat[1, :])

    AAI = zeros(zerotype, col)

    AI = zeros(zerotype, col)

    temp = [decisionMat; AI'; AAI']

    normalizedDecisionMat = similar(temp)

    @inbounds for i = 1:col
        if fns[i] == maximum
            AI[i] = maximum(decisionMat[:, i])
            temp[row+1, i] = AI[i]
            AAI[i] = minimum(decisionMat[:, i])
            temp[row+2, i] = AAI[i]
            normalizedDecisionMat[:, i] = temp[:, i] ./ AI[i]
        elseif fns[i] == minimum
            AI[i] = minimum(decisionMat[:, i])
            temp[row+1, i] = AI[i]
            AAI[i] = maximum(decisionMat[:, i])
            temp[row+2, i] = AAI[i]
            normalizedDecisionMat[:, i] = AI[i] ./ temp[:, i]
        end
    end

    return normalizedDecisionMat
end 

end #end of module Normalizations 