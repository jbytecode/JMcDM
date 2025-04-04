module COPRAS

export copras, CoprasMethod, COPRASResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities



struct CoprasMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

CoprasMethod() = CoprasMethod(Normalizations.dividebycolumnsumnormalization)

struct COPRASResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end



"""
    copras(decisionMat, weights, fs; normalization)
Apply COPRAS (COmplex PRoportional ASsesment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `decisionMat::Matrix`: n × m matrix of objective values for n alternatives and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fs::Array{<:Function,1}`: m-vector of type of criteria. The benefit criteria shown with "maximum", and the cost criteria shown with "minimum".
 - `normalization{<:Function}`: Optional normalization function.

 # Description 
copras() applies the COPRAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::COPRASResult`: COPRASResult object that holds multiple outputs including scores and best index.

# Examples
```julia-repl
julia> decmat = [2.50 240 57 45 1.10 0.333333;
       2.50 285 60 75 4.00 0.428571;
       4.50 320 100 65 7.50 1.111111;
       4.50 365 100 90 7.50 1.111111;
       5.00 400 100 90 11.00 1.111111;
       2.50 225 60 45 1.10 0.333333;
       2.50 270 57 60 4.00 0.428571;
       4.50 330 100 70 7.50 1.111111;
       4.50 365 100 80 7.50 1.111111;
       5.00 380 110 65 8.00 1.111111;
       2.50 285 65 80 4.00 0.400000;
       4.00 280 75 65 4.00 0.400000;
       4.50 365 102 95 7.50 1.111111;
       4.50 400 102 95 7.50 1.111111;
       6.00 450 110 95 11.00 1.176471;
       6.00 510 110 105 11.00 1.176471;
       6.00 330 140 110 18.50 1.395349;
       2.50 240 65 80 4.00 0.400000;
       4.00 280 75 75 4.00 0.400000;
       4.50 355 102 95 7.50 1.111111;
       4.50 385 102 90 7.50 1.111111;
       5.00 385 114 95 7.50 1.000000;
       6.00 400 110 90 11.00 1.000000;
       6.00 480 110 95 15.00 1.000000;
       6.00 440 140 100 18.50 1.200000;
       6.00 500 140 100 18.50 1.200000;
       5.00 450 125 100 15.00 1.714286;
       6.00 500 150 125 18.50 1.714286;
       6.00 515 180 140 22.00 2.307692;
       7.00 550 200 150 30.00 2.307692;
       6.00 500 180 140 15.00 2.307692;
       6.00 500 180 140 18.50 2.307692;
       6.00 500 180 140 22.00 2.307692;
       7.00 500 180 140 30.00 2.307692;
       7.00 500 200 140 37.00 2.307692;
       7.00 500 200 140 45.00 2.307692;
       7.00 500 200 140 55.00 2.307692;
       7.00 500 200 140 75.00 2.307692]
38×6 Array{Float64,2}:
 2.5  240.0   57.0   45.0   1.1  0.333333
 2.5  285.0   60.0   75.0   4.0  0.428571
 4.5  320.0  100.0   65.0   7.5  1.11111
 4.5  365.0  100.0   90.0   7.5  1.11111
 5.0  400.0  100.0   90.0  11.0  1.11111
 2.5  225.0   60.0   45.0   1.1  0.333333
 2.5  270.0   57.0   60.0   4.0  0.428571
 4.5  330.0  100.0   70.0   7.5  1.11111
 4.5  365.0  100.0   80.0   7.5  1.11111
 5.0  380.0  110.0   65.0   8.0  1.11111
 2.5  285.0   65.0   80.0   4.0  0.4
 ⋮                               ⋮
 6.0  500.0  150.0  125.0  18.5  1.71429
 6.0  515.0  180.0  140.0  22.0  2.30769
 7.0  550.0  200.0  150.0  30.0  2.30769
 6.0  500.0  180.0  140.0  15.0  2.30769
 6.0  500.0  180.0  140.0  18.5  2.30769
 6.0  500.0  180.0  140.0  22.0  2.30769
 7.0  500.0  180.0  140.0  30.0  2.30769
 7.0  500.0  200.0  140.0  37.0  2.30769
 7.0  500.0  200.0  140.0  45.0  2.30769
 7.0  500.0  200.0  140.0  55.0  2.30769
 7.0  500.0  200.0  140.0  75.0  2.30769

julia> weights = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667];

julia> fns = [maximum, maximum, maximum, maximum, maximum, minimum];

julia> result = copras(decmat, w, fs);

julia> result.bestIndex
38

julia> result.scores
38-element Array{Float64,1}:
 0.021727395411605937
 0.019814414550092637
 0.01789214190869233
 0.01624057709923278
 0.01507318798582843
 0.021837811311495522
 0.020735423365838293
 0.01754833367014725
 0.016658288043259514
 0.016258710042371068
 0.019388734250223458
 ⋮
 0.01064826476628102
 0.01000964101170639
 0.007056714858865703
 0.010627520153194962
 0.010419795157349462
 0.010212070161503961
 0.00876261130160425
 0.007733739643860005
 0.007258939653356005
 0.006665439665226005
 0.005478439688966004
```
# References
Kaklauskas, A., Zavadskas, E. K., Raslanas, S., Ginevicius, R., Komka, A., & Malinauskas, P. (2006). Selection of low-e windows in retrofit of public buildings by applying multiple criteria method COPRAS: A Lithuanian case. Energy and buildings, 38(5), 454-462.
Özdağoğlu, A. (2013). İmalat işletmeleri için eksantrik pres alternatiflerinin COPRAS yöntemi ile karşılaştırılması. Gümüşhane Üniversitesi Sosyal Bilimler Enstitüsü Elektronik Dergisi, 4(8), 1-22.
Yıldırım, B. F., Timor, M. (2019). "Bulanık ve Gri COPRAS Yöntemleri Kullanılarak Tedarikçi Seçim Modeli Geliştirilmesi". Optimum Ekonomi ve Yönetim Bilimleri Dergisi, 6 (2), 283-310.
"""
function copras(
    decisionMat::Matrix,
    weights::Array{Float64,1},
    fns::Array{F,1};
    normalization::G = Normalizations.dividebycolumnsumnormalization
)::COPRASResult where {F<:Function, G<:Function}

    nrows, ncols = size(decisionMat)
    w = unitize(weights)

    normalizedMat = normalization(decisionMat, fns)
    
    for i in 1:ncols 
        normalizedMat[:,i] = normalizedMat[:, i] .* weights[i]
    end 

    sPlus = zeros(eltype(normalizedMat), nrows)
    sMinus = zeros(eltype(normalizedMat), nrows)


    for row = 1:nrows
        for col = 1:ncols
            if fns[col] == maximum
                sPlus[row] = sPlus[row] + normalizedMat[row, col]
            elseif fns[col] == minimum
                sMinus[row] = sMinus[row] + normalizedMat[row, col]
            end
        end
    end

    Q = zeros(eltype(normalizedMat), nrows)
    Z = sum(1 ./ sMinus)

    for row = 1:nrows
        Q[row] = sPlus[row] + (sum(sMinus) / (sMinus[row] * Z))
    end
    scores = zeros(eltype(normalizedMat), nrows)
    scores = Q ./ maximum(Q)

    rankings = sortperm(scores)
    bestIndex = rankings |> last

    result = COPRASResult(decisionMat, w, scores, rankings, bestIndex)

    return result
end



"""
    copras(setting)
Apply COPRAS (COmplex PRoportional ASsesment) method for a given matrix, weights and, type of criteria.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
 
 # Description 
copras() applies the COPRAS method to rank n alternatives subject to m criteria and criteria type vector.

# Output 
- `::COPRASResult`: COPRASResult object that holds multiple outputs including scores and best index.
"""
function copras(setting::MCDMSetting)::COPRASResult
    copras(setting.df, setting.weights, setting.fns)
end



end # end of module COPRAS 
