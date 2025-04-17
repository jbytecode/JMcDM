struct FuzzyVikorResult
    fplus::Vector{Triangular}
    fminus::Vector{Triangular}
    Si::Vector{Triangular}
end


"""
    fuzzyvikor(decmat::Matrix{Triangular}, w::Vector{Triangular}, fns::Vector{F}) -> FuzzyVikorResult

# Description 

The fuzzy VIKOR method is a multi-criteria decision-making method that uses fuzzy logic to evaluate alternatives based on multiple criteria.

# Arguments
- `decmat::Matrix{Triangular}`: A matrix of fuzzy numbers representing the decision matrix.
- `w::Vector{Triangular}`: A vector of fuzzy numbers representing the weights of the criteria.
- `fns::Vector{F}`: A vector of functions (either `maximum` or `minimum`) representing the type of each criterion.

# Returns
- `FuzzyVikorResult`: A struct containing the results of the fuzzy VIKOR method, including the positive ideal solution, negative ideal solution, and the Si values for each alternative.
"""
function fuzzyvikor(decmat::Matrix{Triangular},
    w::Vector{Triangular},
    fns::Vector{F})::FuzzyVikorResult where {F<:Function}

    n, p = size(decmat)

    fplus = Vector{Triangular}(undef, p)
    fminus = Vector{Triangular}(undef, p)

    for j = 1:p
        currcol = decmat[:, j]
        a = map(first, currcol)
        b = map(x -> x.b, currcol)
        c = map(last, currcol)
        f1p = maximum(a)
        f2p = maximum(b)
        f3p = maximum(c)
        f1n = minimum(a)
        f2n = minimum(b)
        f3n = minimum(c)
        if fns[j] == maximum    
            fplus[j] = Triangular(f1p, f2p, f3p)
            fminus[j] = Triangular(f1n, f2n, f3n)
        elseif fns[j] == minimum
            fminus[j] = Triangular(f1p, f2p, f3p)
            fplus[j] = Triangular(f1n, f2n, f3n)
        else
            error("fns[i] should be either minimum or maximum")
        end
    end


    Si = Vector{Triangular}(undef, n)
    for i in 1:n
        a = 0.0
        b = 0.0
        c = 0.0
        for j in 1:p
            if fns[j] == maximum
                a += w[j].a * (decmat[i, j].a - fminus[j].a)/(fplus[j].a - fminus[j].a)
                b += w[j].b * (decmat[i, j].b - fminus[j].b)/(fplus[j].b - fminus[j].b)
                c += w[j].c * (decmat[i, j].c - fminus[j].c)/(fplus[j].c - fminus[j].c)
            elseif fns[j] == minimum
                a += w[j].a * (fplus[j].a - decmat[i, j].a)/(fplus[j].a - fminus[j].a)
                b += w[j].b * (fplus[j].b - decmat[i, j].b)/(fplus[j].b - fminus[j].b)
                c += w[j].c * (fplus[j].c - decmat[i, j].c)/(fplus[j].c - fminus[j].c)
            else
                error("fns[i] should be either minimum or maximum")
            end
        end 
        
        Si[i] = Triangular(a, b, c)        
    end 

    return FuzzyVikorResult(fplus, fminus, Si)
end