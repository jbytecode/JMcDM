


"""
    struct MCDMSetting 
        df::DataFrame
        weights::Array{Float64, 1}
        fns::Array{Function, 1}
    end

    Immutable data structure for a MCDM setting.

# Arguments
- `df::DataFrame`: The decision matrix in type of DataFrame.
- `weights::Array{Float64,1}`: Array of weights for each criterion.
- `fns::Array{Function, 1}`: Array of functions. The elements are either minimum or maximum.

# Description 
Many methods including Topsis, Electre, Waspas, etc., use a decision matrix, weights, and directions
of optimizations in types of DataFrame, Vector, and Vector, respectively. The type MCDMSetting simply
holds these information to pass them into methods easly. Once a MCDMSetting object is created, the problem
can be passed into several methods like topsis(setting), electre(setting), waspas(setting), etc.  

# Examples

```julia-repl
julia> df = DataFrame();
julia> df[:, :x] = Float64[9, 8, 7];
julia> df[:, :y] = Float64[7, 7, 8];
julia> df[:, :z] = Float64[6, 9, 6];
julia> df[:, :q] = Float64[7, 6, 6];

julia> w = Float64[4, 2, 6, 8];

julia> fns = makeminmax([maximum, maximum, maximum, maximum]);

julia> setting = MCDMSetting(df, w, fns)

julia> result = topsis(setting);
julia> # Same result can be obtained using
julia> result2 = mcdm(setting, TopsisMethod())
```

"""
struct MCDMSetting 
    df::DataFrame
    weights::Array{Float64, 1}
    fns::Array{Function, 1}
end

















