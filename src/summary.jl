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

    if :cocoso in methods
        result = cocoso(decisionMat, weights, fns)
        resultdf[:,:cocoso] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 

    if :critic in methods
        result = critic(decisionMat, fns)
        resultdf[:,:critic] = map(x -> if result.bestIndex == x check else " " end, 1:nalternatives)
    end 


    return resultdf

end