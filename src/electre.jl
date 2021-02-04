function electre(decisionMat::DataFrame, weights::Array{Float64,1})::ElectreResult

    w = unitize(weights)

    nalternatives, ncriteria = size(decisionMat)

    normalizedMat = normalize(decisionMat)
    weightednormalizedMat = w * normalizedMat

    fitnessTable = []
    nonfitnessTable = []

    for i in 1:nalternatives
        for j in 1:nalternatives
            if i != j 
                betterlist = []
                worselist = []
                for h in 1:ncriteria
                    if weightednormalizedMat[i, h] >= weightednormalizedMat[j, h]
                        push!(betterlist, h)    
                    else
                        push!(worselist, h)
                    end
                end
                fitnesstableelement = Dict(:i => i, :j => j, :set => betterlist)
                push!(fitnessTable, fitnesstableelement)

                nonfitnesstableelement = Dict(:i => i, :j => j, :set => worselist)
                push!(nonfitnessTable, nonfitnesstableelement)
            end
        end
    end

    fitnessmatrix = zeros(Float64, nalternatives, nalternatives)
    nonfitnessmatrix = zeros(Float64, nalternatives, nalternatives)

    for elements in fitnessTable
        i = elements[:i]
        j = elements[:j]
        elemlist = elements[:set]
    
        CC = sum(w[elemlist])
        fitnessmatrix[i, j] = CC
    end

    nonfitnessmatrix = zeros(Float64, nalternatives, nalternatives)
    for elements in nonfitnessTable
        i = elements[:i]
        j = elements[:j]
        elemlist = elements[:set]
    
        r_ik       = weightednormalizedMat[i, elemlist]
        r_jk       = weightednormalizedMat[j, elemlist]
        r_ik_full  = weightednormalizedMat[i, :]
        r_jk_full  = weightednormalizedMat[j, :]

        nom = maximum(abs.(r_ik - r_jk))
        dom = maximum(abs.(r_ik_full - r_jk_full))
        nonfitnessmatrix[i, j] = nom / dom
    end

    C = zeros(Float64, nalternatives)
    D = zeros(Float64, nalternatives)
    for i in 1:nalternatives
        C[i] = sum(fitnessmatrix[i, :]) - sum(fitnessmatrix[:, i])
        D[i] = sum(nonfitnessmatrix[i, :]) - sum(nonfitnessmatrix[:, i])
    end

    best_C_index = sortperm(C) |> last 
    best_D_index = sortperm(D) |> first
    best = nothing

    if best_C_index == best_D_index
        best = (best_C_index,)
    else
        best = (best_C_index, best_D_index)
    end

    result = ElectreResult(
        decisionMat,
        w,
        weightednormalizedMat,
        fitnessTable,
        nonfitnessTable,
        fitnessmatrix,
        nonfitnessmatrix,
        C,
        D,
        best     
    )

    return result
end