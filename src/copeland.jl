module Copeland

export copeland 


import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Topsis: TopsisMethod, TopsisResult, topsis
import ..ARAS: ArasMethod, ARASResult, aras
import ..COCOSO: CocosoMethod, cocoso
import ..CODAS: CodasMethod, codas
import ..COPRAS: CoprasMethod, copras
import ..EDAS: EdasMethod, edas
import ..MABAC: MabacMethod, mabac
import ..MAIRCA: MaircaMethod, mairca
import ..MARCOS: MarcosMethod, marcos
import ..MOORA: MooraMethod, moora
import ..MOOSRA: MoosraMethod, moosra
import ..PIV: PIVMethod, piv
import ..PSI: PSIMethod, psi
import ..ROV: ROVMethod, rov
import ..SAW: SawMethod, saw
import ..VIKOR: VikorMethod, vikor
import ..WASPAS: WaspasMethod, waspas
import ..WPM: WPMMethod, wpm




function level_of_dominance(v1::Array{Int,1}, v2::Array{Int,1})::Int64
    lod = zero(Int64)
    n = length(v1)
    for i = 1:n
        if v1[i] < v2[i]
            lod += 1
        end
    end
    return lod
end

function dominance_scores(ordering_mat::Array{Int,2})::Array{Int,2}
    n, _ = size(ordering_mat)
    lev_dom = zeros(Int64, n, n)
    for i = 1:n
        for j = 1:n
            lev_dom[i, j] = level_of_dominance(ordering_mat[i, :], ordering_mat[j, :])
        end
    end
    return lev_dom
end

function winloss_scores(dommat::Array{Int,2})::Array{Int,2}
    n, _ = size(dommat)
    winlossmat = zeros(Int64, n, n)
    for i = 1:n
        for j = 1:n
            winlossmat[i, j] = Int(sign(dommat[i, j] - dommat[j, i]))
        end
    end
    return winlossmat
end



"""
        copeland(ordering_mat)

# Arguments
 - `ordering_mat`::Array{Int, 2}`: Ordering matrix.

# Description 
The function takes an ordering matrix as input. Different ordering results are in columns.
Orderings are in ascending order. The function returns the ranks. The alternative with rank 
1 is the winner. 

# Output 
- `::Array{Int, 1}`: Vector of ranks.
"""
function copeland(ordering_mat::Array{Int,2})::Array{Int,1}
    winlosses = ordering_mat |> dominance_scores |> winloss_scores
    n, _ = size(winlosses)
    scores = map(i -> Int(sum(winlosses[i, :])), 1:n)
    return scores
end

"""
# Example 

```julia-repl
julia> using JMcDM

julia> df = DataFrame(
    :c1 => [1.0, 2, 3, 4],
    :c2 => [5.0, 6, 7, 8],
    :c3 => [10.0, 11, 12, 13],
    :c4 => [20.0, 30, 40, 360],
)

julia> weights = [0.25, 0.25, 0.25, 0.25]
julia> fns = [maximum, maximum, maximum, maximum]

julia> met = [
    PIVMethod(),
    PSIMethod(),
    ROVMethod(),
    SawMethod(),
    VikorMethod(),
    WaspasMethod(),
    WPMMethod(),
]

julia> result = copeland(df, w, fns, met)

4×8 DataFrame
 Row │ Piv    Psi    Rov    Saw    Vikor  Waspas  Wpm    Copeland 
     │ Int64  Int64  Int64  Int64  Int64  Int64   Int64  Int64    
─────┼────────────────────────────────────────────────────────────
   1 │     1      1      1      1      1       1      1         3
   2 │     2      2      2      2      2       2      2         1
   3 │     3      3      3      3      3       3      3        -1
   4 │     4      4      4      4      4       4      4        -3
```

"""
function copeland(df::Matrix, w::Vector, fns::Vector, methods::Vector{T}) where {T <: MCDMMethod}
    nmethods = length(methods)
    ncases, _ = size(df)
    scoresmat = zeros(Int64, (ncases, nmethods))
    dictt = Dict()

    for i in 1:nmethods
        if methods[i] isa TopsisMethod
            dictt["Topsis"] = topsis(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa ArasMethod 
            dictt["Aras"] = aras(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa CocosoMethod
            dictt["Cocoso"] = cocoso(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa CodasMethod
            dictt["Codas"] = codas(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa CoprasMethod
            dictt["Copras"] = copras(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa EdasMethod
            dictt["Edas"] = edas(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa MabacMethod
            dictt["Mabac"] = mabac(df, w, fns).scores |> sortperm |> invperm
        elseif methods[i] isa MaircaMethod
            dictt["Mairca"] = mairca(df, w, fns).scores  |> x->sortperm(x, rev = true) 
        elseif methods[i] isa MarcosMethod
            dictt["Marcos"] = marcos(df, w, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa MooraMethod
            dictt["Moora"] = moora(df, w, fns).scores  |> x->sortperm(x, rev = true) 
        elseif methods[i] isa MoosraMethod
            dictt["Moosra"] = moosra(df, w, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa PIVMethod
            dictt["Piv"] = piv(df, w, fns).scores  |> x->sortperm(x, rev = true) 
        elseif methods[i] isa PSIMethod
            dictt["Psi"] = psi(df, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa ROVMethod
            dictt["Rov"] = rov(df, w, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa SawMethod
            dictt["Saw"] = saw(df, w, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa VikorMethod
            dictt["Vikor"] = vikor(df, w, fns).scores  |> x->sortperm(x, rev = true) 
        elseif methods[i] isa WaspasMethod
            dictt["Waspas"] = waspas(df, w, fns).scores  |> sortperm |> invperm
        elseif methods[i] isa WPMMethod
            dictt["Wpm"] = wpm(df, w, fns).scores  |> sortperm |> invperm
        end
    end  

    i = 1
    names = []
    resultdict = dictt
    for (k, v) in dictt
        scoresmat[:, i] = v
        append!(names, k)
        i+=1
    end
    allresult = copeland(scoresmat)
    resultdict["Copeland"] = allresult

    return resultdict
end

end # end of module
