function dematel(comparisonMat::DataFrame; threshold=nothing)

    n, _ = size(comparisonMat)

    csums =  colsums(comparisonMat)
    rsums =  rowsums(comparisonMat)

    largest = maximum(vcat(csums, rsums))

    K = convert(Array{Float64,2}, comparisonMat)
    ND = K ./ largest
  
    T = ND * inv(I(n) - ND)

    c = rowsums(T)
    r = colsums(T)

    c_plus_r  = c .+ r
    c_minus_r = c .- r
  
    if threshold === nothing 
        threshold = sum(T) / length(T)
    end

    influence_matrix = zeros(Float64, n, n)
    for i in 1:n
        for j in 1:n
            if T[i, j] > threshold
                influence_matrix[i, j] = 1
            end
        end
    end

    w_row = sqrt.((c_plus_r.^2.0) .+ (c_minus_r.^2.0))
    w = w_row ./ sum(w_row)

    
    result = DematelResult(
        comparisonMat,
        ND,
        T,
        c,
        r,
        c_plus_r,
        c_minus_r,
        threshold,
        influence_matrix,
        w
    )

    return result
end