module Normalizations 

import ..Utilities: normalize

function vectornormnormalization(data::Matrix)::Matrix
    df = similar(data)
    _, p = size(df)
    for i = 1:p
        df[:, i] = normalize(data[:, i])
    end
    return df
end

function dividebycolumnsumnormalization(data::Matrix)::Matrix 
    normalizedMat = similar(data)

    nrows, ncols = size(data)

    for col = 1:ncols
        for row = 1:nrows
            normalizedMat[row, col] = data[row, col] ./ sum(data[:, col])
        end
    end

    return normalizedMat
end

end #end of module Normalizations 