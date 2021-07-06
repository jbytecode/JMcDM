"""
        grey(decisionMat, weights, fs; zeta)

    Perform GRA (Grey Relational Analysis) for a given decision matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of decision matrix in type of DataFrame. 
 - `weights::Array{Float64, 1}`: m-vector of weights for criteria.
 - `fs::Array{Function, 1}`: m-vector of functions that are either maximize or minimize for each single criterion.
 - `zeta::Float64`: zeta parameter for the algorithm. The default is 0.5.
 
# Description 
Applies GRA (Grey Relational Analysis).

# Output 
- `::GreyResult`: GreyResult object that holds many values including ordering of strategies or candidates and best index.

# Examples
```julia-repl
julia> # Decision matrix of 5 candidates and 6 criteria.
julia> df = DataFrame(
               :K1 => [105000.0, 120000, 150000, 115000, 135000],
               :K2 => [105.0, 110, 120, 105, 115],
               :K3 => [10.0, 15, 12, 20, 15],
               :K4 => [4.0, 4, 3, 4, 5],
               :K5 => [300.0, 500, 550, 600, 400],
               :K6 => [10.0, 8, 12, 9, 9]
        )
5×6 DataFrame
 Row │ K1        K2       K3       K4       K5       K6      
     │ Float64   Float64  Float64  Float64  Float64  Float64 
─────┼───────────────────────────────────────────────────────
   1 │ 105000.0    105.0     10.0      4.0    300.0     10.0
   2 │ 120000.0    110.0     15.0      4.0    500.0      8.0
   3 │ 150000.0    120.0     12.0      3.0    550.0     12.0
   4 │ 115000.0    105.0     20.0      4.0    600.0      9.0
   5 │ 135000.0    115.0     15.0      5.0    400.0      9.0

julia> # Direction of optimization for each single criterion
julia> functionlist = [minimum, maximum, minimum, maximum, maximum, minimum];

julia> # Weights
julia> w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40];

julia> result = grey(df, w, functionlist);

julia> result.scores
5-element Array{Float64,1}:
 0.525
 0.7007142857142857
 0.5464285714285715
 0.5762820512820512
 0.650952380952381

julia> result.bestIndex
2
```

# References
İşletmeciler, Mühendisler ve Yöneticiler için Operasyonel, Yönetsel ve Stratejik Problemlerin
Çözümünde Çok Kriterli Karar verme Yöntemleri, Editörler: Bahadır Fatih Yıldırım ve Emrah Önder,
Dora, 2. Basım, 2015, ISBN: 978-605-9929-44-8
"""
function grey(decisionMat::DataFrame, weights::Array{Float64,1}, fs::Array{Function,1}; zeta::Float64=0.5)::GreyResult

    #mat = convert(Matrix, decisionMat)
    mat = Matrix(decisionMat)

    nrows, ncols = size(mat)

    w = unitize(weights)

    referenceRow = apply_columns(fs, mat)

    normalizedReferenceRow = zeros(Float64, ncols)

    normalizedMat = similar(mat)
    for col in 1:ncols
        mmax = maximum(mat[:, col])
        mmin = minimum(mat[:, col])
        mrange = mmax - mmin
        for row in 1:nrows
            if fs[col] == maximum 
                normalizedMat[row, col] = (mat[row, col] - mmin) / mrange
            elseif fs[col] == minimum 
                normalizedMat[row, col] = (mmax - mat[row, col]) / mrange
            else
                @error fs[col]
                error("Function not defined")
            end
        end
        if fs[col] == maximum
            normalizedReferenceRow[col] = (referenceRow[col] - mmin) / mrange
        elseif fs[col] == minimum 
            normalizedReferenceRow[col] = (mmax - referenceRow[col]) / mrange
        end
    end

    absoluteValueMat = similar(mat)
    for row in 1:nrows
        absoluteValueMat[row,:] = normalizedReferenceRow .- normalizedMat[row, :]  .|> abs 
    end

    deltamin = absoluteValueMat |> minimum
    deltamax = absoluteValueMat |> maximum
    zetadeltamax = zeta * deltamax

    greytable = similar(absoluteValueMat)
    for row in 1:nrows
        for col in 1:ncols
            greytable[row, col] = (deltamin + zetadeltamax) / (absoluteValueMat[row, col] + zetadeltamax) 
        end
    end

    weightedsums = zeros(Float64, nrows)
    for i in 1:nrows
        weightedsums[i] = w .* greytable[i, :] |> sum 
    end

    orderings = sortperm(weightedsums)
    bestIndex = orderings |> last

    result = GreyResult(
        referenceRow,
        normalizedMat,
        absoluteValueMat,
        greytable,
        weightedsums,
        orderings,
        bestIndex
    )
    
    return result
end


"""
        grey(setting; zeta)

    Perform GRA (Grey Relational Analysis) for a given decision matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 - `zeta::Float64`: zeta parameter for the algorithm. The default is 0.5.
 
# Description 
Applies GRA (Grey Relational Analysis).

# Output 
- `::GreyResult`: GreyResult object that holds many values including ordering of strategies or candidates and best index.
"""
function grey(setting::MCDMSetting; zeta::Float64=0.5)::GreyResult
    grey(
        setting.df,
        setting.weights,
        setting.fns
    )
end 
