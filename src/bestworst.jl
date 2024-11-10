module BestWorstMethod

export bestworst
export BestWorstResult


using ..JuMP, ..Ipopt

struct BestWorstResult
    ε::Float64
    weights::Vector
    is_solved_and_feasible::Bool
end


"""
    bestworst(pref_to_best::Vector{Int}, pref_to_worst::Vector{Int})::BestWorstResult

    The Best-Worst Method is a method for deriving weights from preference information. 
    The method is based on the idea that the best alternative should be as close as possible to the best alternative 
    and as far as possible from the worst alternative. 

    In `pref_to_best`, the best alternative should have the highest preference value of 1. 
    Similarly, in `pref_to_worst`, the worst alternative should have the highest preference value of 1.

# Arguments

- `pref_to_best::Vector{Int}`: Vector of preferences for the best alternative. 
- `pref_to_worst::Vector{Int}`: Vector of preferences for the worst alternative.

# Returns

- `BestWorstResult`: A struct with the following fields:
    - `ε::Float64`: The value of epsilon.
    - `weights::Vector`: The weights of the alternatives.

# Example

```julia
using JMcDM
pref_to_best = [8, 2, 1]
pref_to_worst = [1, 5, 8]
result = bestworst(pref_to_best, pref_to_worst)
```

# References

- Rezaei, Jafar. "Best-worst multi-criteria decision-making method." Omega 53 (2015): 49-57.

!!! warning "Dependencies"
    This method is enabled when the JuMP and Ipopt packages are installed and loaded.
    Please first load the JuMP and Ipopt packages before using this method.
    The method is not available in the JMcDM module until the JuMP and Ipopt packages are loaded.
"""
function bestworst(pref_to_best::Vector{Int}, pref_to_worst::Vector{Int})::BestWorstResult

    n = length(pref_to_best)

    if n != length(pref_to_worst)
        throw(ArgumentError("The lengths of the preference vectors are not equal."))
    end

    best_index = argmin(pref_to_best)

    if pref_to_best[best_index] != 1
        throw(ArgumentError("The best index must have the highest preference value of 1."))
    end

    worst_index = argmin(pref_to_worst)

    if pref_to_worst[worst_index] != 1
        throw(ArgumentError("The worst index must have the highest preference value of 1."))
    end

    model = Model(Ipopt.Optimizer)

    set_silent(model)

    @variable(model, ε >= 0)

    # Starting point of the weights on [0, 0, ..., 0] is not feasible 
    # Set the initial values to 1/n
    @variable(model, w[1:n] >= 0, start = 1/n)

    @objective(model, Min, ε)

    indices = collect(1:n)

    bestindices = indices[indices.!=best_index]
    
    worstindices = indices[indices.!=worst_index]

    for i in bestindices
        # abs(w[best_index] / w[i] - pref_to_best[i]) <= ε
        @constraint(model, (w[best_index] / w[i] - pref_to_best[i]) <= ε)
        @constraint(model, -ε <= (w[best_index] / w[i] - pref_to_best[i]))
    end

    for i in worstindices
        # abs(w[i] / w[worst_index] - pref_to_worst[i]) <= ε
        @constraint(model, (w[i] / w[worst_index] - pref_to_worst[i]) <= ε)
        @constraint(model, -ε <= (w[i] / w[worst_index] - pref_to_worst[i]))
    end

    @constraint(model, sum(w) == 1)

    optimize!(model)

    status = JuMP.is_solved_and_feasible(model)
    result = BestWorstResult(value(ε), value.(w), status)

    return result
end

end # module