"""
        marcos(decisionMat, weights, fns)

Apply MARCOS (Measurement Alternatives and Ranking according to COmpromise Solution) for a given matrix and weights.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alterntives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns. 

# Description 
marcos() applies the MARCOS method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MARCOSResult`: MARCOSResult object that holds multiple outputs including scores, rankings, and best index.

# Examples
```julia-repl
julia> decmat = [8.675 8.433 8.000 7.800 8.025 8.043;
       8.825 8.600 7.420 7.463 7.825 8.229;
       8.325 7.600 8.040 7.700 7.925 7.600;
       8.525 8.667 7.180 7.375 7.750 8.071]
4×6 Array{Float64,2}:
 8.675  8.433  8.0   7.8    8.025  8.043
 8.825  8.6    7.42  7.463  7.825  8.229
 8.325  7.6    8.04  7.7    7.925  7.6
 8.525  8.667  7.18  7.375  7.75   8.071

julia> df = makeDecisionMatrix(decmat)

4×6 DataFrame
 Row │ Crt1     Crt2     Crt3     Crt4     Crt5     Crt6    
     │ Float64  Float64  Float64  Float64  Float64  Float64 
─────┼──────────────────────────────────────────────────────
   1 │   8.675    8.433     8.0     7.8      8.025    8.043
   2 │   8.825    8.6       7.42    7.463    7.825    8.229
   3 │   8.325    7.6       8.04    7.7      7.925    7.6
   4 │   8.525    8.667     7.18    7.375    7.75     8.071

julia> weights = [0.1901901901901902 , 0.15915915915915918 , 0.19819819819819823, 0.1901901901901902, 0.15115115115115116, 0.11111111111111112];

julia> fns = [maximum, maximum, maximum, maximum, maximum, maximum];

julia> Fns = convert(Array{Function, 1} , fns)

julia> result = marcos(df, weights, Fns);

julia> result.scores
4-element Array{Float64,1}:
 0.6848657890705123
 0.6727670074308345
 0.6625969531206817
 0.6611030275027843

julia> result.bestIndex
1
```

# References
Stević, Z., Pamučar, D., Puška, A., Chatterjee, P., Sustainable supplier selection in healthcare industries using a new MCDM method: Measurement Alternatives and Ranking according to COmpromise Solution (MARCOS), Computers & Industrial Engineering (2019), doi: https://doi.org/10.1016/j.cie.2019.106231

Puška, A., Stojanović, I., Maksimović, A., & Osmanović, N. (2020). Evaluation software of project management used measurement of alternatives and ranking according to compromise solution (MARCOS) method. Operational Research in Engineering Sciences: Theory and Applications, 3(1), 89-102.
"""
function marcos(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::MARCOSResult

    # df = convert(Matrix, decisionMat)
    df = Matrix(decisionMat)
    
    row, col = size(df)

    w = unitize(weights)

    AAI = zeros(Float64, col)
    AI  = zeros(Float64, col)
            
    temp = [df; AI'; AAI']

    normalizedDecisionMat = similar(temp)

    @inbounds for i in 1:col
        if fns[i] == maximum
            AI[i] = maximum(df[:, i])
            temp[row + 1, i] = AI[i]
            AAI[i] = minimum(df[:, i])
            temp[row + 2, i] = AAI[i]
            normalizedDecisionMat[:, i] = temp[:, i] ./ AI[i] 
        elseif fns[i] == minimum
            AI[i] = minimum(df[:, i])
            temp[row + 1, i] = AI[i]
            AAI[i] = maximum(df[:, i])
            temp[row + 2, i] = AAI[i]
            normalizedDecisionMat[:, i] = AI[i] ./ temp[:, i]
        end
    end
    
    #S  = zeros(Float64, col)
    S = zeros(Float64, row + 2)
    
    for i in 1:row + 2
        S[i] = w .* normalizedDecisionMat[i, :] |> sum
    end

    KPlus  = S[1:row] ./ S[row + 1]
    KMinus  = S[1:row] ./ S[row + 2]

    fKPlus = KPlus ./ (KPlus .+ KMinus)
    fKMinus = KMinus ./ (KPlus .+ KMinus)

    scores = zeros(Float64, row)
    for i in 1:row
        scores[i] = (KPlus[i] + KMinus[i]) / ((1 + (1 - fKPlus[i]) / fKPlus[i]) + ((1 - fKMinus[i]) / fKMinus[i]))
    end
    rankings = sortperm(scores)
    
    bestIndex = rankings |> last
    
    result = MARCOSResult(
        decisionMat,
        w,
        scores,
        rankings,
        bestIndex
    )

    return result
end


"""
        marcos(setting)

Apply MARCOS (Measurement Alternatives and Ranking according to COmpromise Solution) for a given matrix and weights.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting 
 
# Description 
marcos() applies the MARCOS method to rank n alterntives subject to m criteria which are supposed to be 
either maximized or minimized.

# Output 
- `::MARCOSResult`: MARCOSResult object that holds multiple outputs including scores, rankings, and best index.
"""
function marcos(setting::MCDMSetting)::MARCOSResult
    marcos(
        setting.df,
        setting.weights,
        setting.fns
    )
end 