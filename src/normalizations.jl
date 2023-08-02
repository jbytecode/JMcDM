module Normalizations 

import ..Utilities: normalize, colmins, colmaxs

function vectornormnormalization(data::Matrix, fns)::Matrix
    return normalize(data)
end

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

end #end of module Normalizations 