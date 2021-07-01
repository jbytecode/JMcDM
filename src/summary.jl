"""
        summary(decisionMat, weights, fns, methods)

Apply more methods for a given decision problem. The methods accept standart number of arguments.   

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n candidate (or strategy) and m criteria 
 - `weights::Array{Float64, 1}`: m-vector of weights that sum up to 1.0. If the sum of weights is not 1.0, it is automatically normalized.
 - `fns::Array{Function, 1}`: m-vector of function that are either minimize or maximize.
 - `methods::Array{Symbol, 1}`: Array of symbols. The elements can be :topsis, :electre, :cocoso, :copras, :moora, :vikor, :grey, :aras, :saw, :wpm, :waspas, :edas, :marcos, :mabac, :mairca, :copras, :critic

# Description 
    This method outputs a summarized output using more than MCDM methods in a comparable way. 

    # Output 
- `::DataFrame`: A DataFrame object, methods in columns, and alternatives in rows. Green check symbol indicates the selected alternative as the best by the corresponding method.

# Examples
```julia-repl
julia> df = DataFrame(
:age        => [6.0, 4, 12],
:size       => [140.0, 90, 140],
:price      => [150000.0, 100000, 75000],
:distance   => [950.0, 1500, 550],
:population => [1500.0, 2000, 1100]);


julia> methods = [:topsis, :electre, :vikor, :moora, :cocoso, :wpm, :waspas]

julia> w  = [0.036, 0.192, 0.326, 0.326, 0.12];

julia> fns = [maximum, minimum, maximum, maximum, maximum];


julia> result = summary(df, w, fns, methods)
3×7 DataFrame
 Row │ topsis  electre  cocoso  moora   vikor   wpm     waspas 
     │ String  String   String  String  String  String  String 
─────┼─────────────────────────────────────────────────────────
   1 │                           ✅      ✅
   2 │  ✅      ✅       ✅                      ✅      ✅
   3 │

```
"""
function summary(
    decisionMat::DataFrame, 
    weights::Array{Float64,1}, 
    fns::Array{Function,1}, 
    methods::Array{Symbol,1})

    nmethods = length(methods)
    nalternatives, _ = size(decisionMat)

    resultdf = DataFrame()

    check = " ✅ "

    if :topsis in methods
        topresult = topsis(decisionMat, weights, fns)
        resultdf[:,:topsis] = map(x -> if topresult.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :electre in methods
        # electre best index is a tuple 
        result = electre(decisionMat, weights, fns)
        resultdf[:,:electre] = map(x -> if x in result.bestIndex check else " " end, 1:nalternatives)
    end 

    if :cocoso in methods
        result = cocoso(decisionMat, weights, fns)
        resultdf[:,:cocoso] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :copras in methods
        result = copras(decisionMat, weights, fns)
        resultdf[:,:copras] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :moora in methods
        result = moora(decisionMat, weights, fns)
        resultdf[:,:moora] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end

    if :vikor in methods
        result = vikor(decisionMat, weights, fns)
        resultdf[:,:vikor] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end

    if :grey in methods
        result = grey(decisionMat, weights, fns)
        resultdf[:,:grey] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end

    if :aras in methods
        result = aras(decisionMat, weights, fns)
        resultdf[:,:aras] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :saw in methods
        result = saw(decisionMat, weights, fns)
        resultdf[:,:saw] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :wpm in methods
        result = wpm(decisionMat, weights, fns)
        resultdf[:,:wpm] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :waspas in methods
        result = waspas(decisionMat, weights, fns)
        resultdf[:,:waspas] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :edas in methods
        result = edas(decisionMat, weights, fns)
        resultdf[:,:edas] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :marcos in methods
        result = marcos(decisionMat, weights, fns)
        resultdf[:,:marcos] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :mabac in methods
        result = mabac(decisionMat, weights, fns)
        resultdf[:,:mabac] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :mairca in methods
        result = mairca(decisionMat, weights, fns)
        resultdf[:,:mairca] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :copras in methods
        result = copras(decisionMat, weights, fns)
        resultdf[:,:copras] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :critic in methods
        result = critic(decisionMat, fns)
        resultdf[:,:critic] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 


    return resultdf

end




function summary(setting::MCDMSetting, methods::Array{Symbol,1})
    summary(
        setting.df,
        setting.weights,
        setting.fns,
        methods
    )
end 
