module DEMATEL

export dematel, DematelResult


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities



struct DematelResult <: MCDMResult
    comparisonMatrix::Matrix
    NDMatrix::Array{Float64,2}
    relationShipMatrix::Array{Float64,2}
    c::Array{Float64,1}
    r::Array{Float64,1}
    c_plus_r::Array{Float64,1}
    c_minus_r::Array{Float64,1}
    threshold::Float64
    influenceMatrix::Array{Float64,2}
    weights::Array{Float64,1}
end

"""
        dematel(comparisonMat; threshold = nothing)

Apply Dematel for a given comparison matrix.


# Arguments:
 - `comparisonMat::Matrix`: n × n Matrix of input values where n is the number of criteria. Values are either 0, 1, 2, 3, or 4 which indicate the level of importance of the ith criterion relative to the jth criterion.
 - `threshold::Union{Nothing, Float64}`: Optional threshold used in calculating values of influence matrix. It is calculated when the argument is omitted. 

# Description 
dematel() applies the Dematel method to calculate criteria weights, possibly for use in another multi-criteria decision making tool.

# Output 
- `::DematelResult`: DematelResult object that holds many results including weights for each single criterion.

# Examples
```julia-repl
julia> K = [
        0 3 0 2 0 0 0 0 3 0;
        3 0 0 0 0 0 0 0 0 2;
        4 1 0 2 1 3 1 2 3 2;
        4 1 4 0 1 2 0 1 0 0;
        3 2 3 1 0 3 0 2 0 0;
        4 1 4 4 0 0 0 1 1 3;
        3 0 0 0 0 2 0 0 0 0;
        3 0 4 3 2 3 1 0 0 0;
        4 3 2 0 0 1 0 0 0 2;
        2 1 0 0 0 0 0 0 3 0
    ];

julia> result = dematel(K);

julia> result.weights
10-element Array{Float64,1}:
 0.1686568559124561
 0.07991375718719543
 0.14006200243438863
 0.10748052790517183
 0.08789022388276985
 0.12526272598854982
 0.03067915023486491
 0.10489168834828348
 0.092654758940811
 0.06250830916550884
```

# References
Celikbilek Yakup, Cok Kriterli Karar Verme Yontemleri, Aciklamali ve Karsilastirmali
Saglik Bilimleri Uygulamalari ile. Editor: Muhlis Ozdemir, Nobel Kitabevi, Ankara, 2018
"""
function dematel(
    comparisonMat::Matrix;
    threshold::Union{Nothing,Float64} = nothing,
)::DematelResult

    n, _ = size(comparisonMat)

    csums = colsums(comparisonMat)
    rsums = rowsums(comparisonMat)

    largest = maximum(vcat(csums, rsums))

    # K = convert(Array{Float64,2}, comparisonMat)
    K = Matrix{Float64}(comparisonMat)
    ND = K ./ largest

    T = ND * inv(I(n) - ND)

    c = rowsums(T)
    r = colsums(T)

    c_plus_r = c .+ r
    c_minus_r = c .- r

    if threshold === nothing
        threshold = sum(T) / length(T)
    end

    influence_matrix = zeros(Float64, n, n)
    for i = 1:n
        for j = 1:n
            if T[i, j] > threshold
                influence_matrix[i, j] = 1
            end
        end
    end

    w_row = sqrt.((c_plus_r .^ 2.0) .+ (c_minus_r .^ 2.0))
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
        w,
    )

    return result
end



end # end of module DEMATEL 
