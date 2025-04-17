mutable struct FuzzyEdasResult
    w::Vector
    decmat::Matrix
    fns::Vector
    defuzmatrix::Matrix
    avgdefuz::Vector
    pda::Matrix
    nda::Matrix
    wpda::Matrix
    wnda::Matrix
    sp::Vector
    sn::Vector
    sp_defuz::Vector
    sn_defuz::Vector
    nsp::Vector
    nsn::Vector
    as::Vector
    scores::Vector
    ranks::Vector
end

"""
    fuzzyedas(decmat::Matrix{Triangular}, w::Vector{Triangular}, fns)

    Fuzzy EDAS method for decision making.

# Arguments

- `decmat`: A matrix of triangular fuzzy numbers representing the decision matrix.
- `w`: A vector of triangular fuzzy numbers representing the weights.
- `fns`: A vector of functions (maximum or minimum) for each criterion.

# Returns

- An instance of `FuzzyEdasResult` containing the results of the EDAS method.

"""
function fuzzyedas(decmat::Matrix{Triangular}, w::Vector{Triangular}, fns)

    n, p = size(decmat)

    defuzzification_function = x -> defuzzification(x, ArithmeticMean())

    defuzmatrix = zeros(Float64, n, p)

    for i = 1:n
        for j = 1:p
            defuzmatrix[i, j] = defuzzification_function(decmat[i, j])
        end
    end

    avgdefuz = zeros(Float64, p)
    for j = 1:p
        avgdefuz[j] = sum(defuzmatrix[:, j]) / n
    end

    pda = zeros(Triangular, n, p)
    nda = zeros(Triangular, n, p)
    wpda = zeros(Triangular, n, p)
    wnda = zeros(Triangular, n, p)
    sp = zeros(Triangular, n)
    sn = zeros(Triangular, n)
    sp_defuz = zeros(Float64, n)
    sn_defuz = zeros(Float64, n)
    nsp = zeros(Triangular, n)
    nsn = zeros(Triangular, n)
    as = zeros(Triangular, n)
    scores = zeros(Float64, n)
    ranks = zeros(Int64, n)

    for i in 1:n
        for j in 1:p
            amean = map(x -> x.a, decmat[:, j]) |> mean
            bmean = map(x -> x.b, decmat[:, j]) |> mean
            cmean = map(x -> x.c, decmat[:, j]) |> mean
            if fns[j] == maximum
                if avgdefuz[j] <= defuzmatrix[i, j]
                    a = (decmat[i, j].a - cmean) / avgdefuz[j]
                    b = (decmat[i, j].b - bmean) / avgdefuz[j]
                    c = (decmat[i, j].c - amean) / avgdefuz[j]
                    pda[i, j] = Triangular(sort([a, b, c]))
                    nda[i, j] = Triangular(0, 0, 0)
                else
                    a = (amean - decmat[i, j].c) / avgdefuz[j]
                    b = (bmean - decmat[i, j].b) / avgdefuz[j]
                    c = (cmean - decmat[i, j].a) / avgdefuz[j]
                    nda[i, j] = Triangular(sort([a, b, c]))
                    pda[i, j] = Triangular(0, 0, 0)
                end
            elseif fns[j] == minimum
                if avgdefuz[j] <= defuzmatrix[i, j]
                    a = (decmat[i, j].a - cmean) / avgdefuz[j]
                    b = (decmat[i, j].b - bmean) / avgdefuz[j]
                    c = (decmat[i, j].c - amean) / avgdefuz[j]
                    nda[i, j] = Triangular(sort([a, b, c]))
                    pda[i, j] = Triangular(0, 0, 0)
                else
                    a = (amean - decmat[i, j].c) / avgdefuz[j]
                    b = (bmean - decmat[i, j].b) / avgdefuz[j]
                    c = (cmean - decmat[i, j].a) / avgdefuz[j]
                    pda[i, j] = Triangular(sort([a, b, c]))
                    nda[i, j] = Triangular(0, 0, 0)
                end
            else
                error("Unsupported function: $(fns[p])")
            end
        end
    end

    # Weighted PDA and NDA
    for i in 1:n
        for j in 1:p
            wpda[i, j] = Triangular(sort([w[j].a * pda[i, j].a, w[j].b * pda[i, j].b, w[j].c * pda[i, j].c]))
            wnda[i, j] = Triangular(sort([w[j].a * nda[i, j].a, w[j].b * nda[i, j].b, w[j].c * nda[i, j].c]))
        end
    end

    # SP and SN 
    for i in 1:n
        a = sum(map(x -> x.a, wpda[i, :]))
        b = sum(map(x -> x.b, wpda[i, :]))
        c = sum(map(x -> x.c, wpda[i, :]))
        sp[i] = Triangular(a, b, c)

        a = sum(map(x -> x.a, wnda[i, :]))
        b = sum(map(x -> x.b, wnda[i, :]))
        c = sum(map(x -> x.c, wnda[i, :]))
        sn[i] = Triangular(a, b, c)
    end

    # SP defuz and NP defuz
    for i in 1:n
        sp_defuz[i] = defuzzification_function(sp[i])
        sn_defuz[i] = defuzzification_function(sn[i])
    end

    # NSP and NSN 
    max_sp_defuz = maximum(sp_defuz)
    max_sn_defuz = maximum(sn_defuz)
    for i in 1:n
        nsp[i] = Triangular(sp[i].a / max_sp_defuz, sp[i].b / max_sp_defuz, sp[i].c / max_sp_defuz)
        nsn[i] = Triangular(1 - (sn[i].c / max_sn_defuz), 1 - (sn[i].b / max_sn_defuz), 1 - (sn[i].a / max_sn_defuz))
        as[i] = Triangular(0.5 * (nsp[i].a + nsn[i].a), 0.5 * (nsp[i].b + nsn[i].b), 0.5 * (nsp[i].c + nsn[i].c))
    end

    # Scores are Defuz of AS 
    for i in 1:n
        scores[i] = defuzzification_function(as[i])
    end


    ranks = (sortperm(scores, rev=true) |> invperm)


    # FuzzyEdasResult construction
    edasresult = FuzzyEdasResult(
        w, 
        decmat, 
        fns, 
        defuzmatrix, 
        avgdefuz,
        pda, 
        nda, 
        wpda, 
        wnda, 
        sp, 
        sn, 
        sp_defuz, 
        sn_defuz, 
        nsp, nsn, 
        as, 
        scores, 
        ranks)


    return edasresult
end