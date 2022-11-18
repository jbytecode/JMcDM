module Game

export game
export GameResult

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
using ..Utilities


using ..JuMP, ..GLPK


struct GameResult <: MCDMResult
    probabilities::Array{Float64,1}
    value::Float64
end

function Base.show(io::IO, result::GameResult)
    println(io, "Probabilities:")
    println(io, result.probabilities)
    println(io, "Value of game: ")
    println(io, result.value)
end

function Base.show(io::IO, result::Array{GameResult,1})
    println(io, "Row Player: ")
    println(io, result[1])
    println(io, "Column Player: ")
    println(io, result[2])
end

"""
        game(decisionMatrix; verbose = false)

    Solve the zero-sum game.

# Arguments:
 - `decisionMatrix::Array{Float,2}`: n × m matrix of gain values for row player. 
 - `verbose::Bool`: Logical value indicating whether the optimization logs are shown or not. Default is false. 

# Description 
game() solves zero-sum games using a gain matrix designed for the row player. The game matrix has n rows 
and m columns for n and m strategies of row and column players, respectively. 

# Output 
- `::Array{GameResult, 1}`: Vector of GameResult objects that holds mixed strategy probabilities for row 
and column players and the value of game. If a pure strategy exists, than the propabilities vector is a one-hat vector.

# Examples
```julia-repl
julia> # Rock & Paper & Scissors game
julia> mat = [0 -1 1; 1 0 -1; -1 1 0]
3×3 Array{Int64,2}:
  0  -1   1
  1   0  -1
 -1   1   0

julia> result = game(mat);

julia> result
Row Player: 
Probabilities:
[0.3333333333333333, 0.3333333333333333, 0.3333333333333333]
Value of game: 
0.0

Column Player: 
Probabilities:
[0.3333333333333333, 0.3333333333333333, 0.3333333333333333]
Value of game: 
0.0
```

# References
Zhou, Hai-Jun. "The rock–paper–scissors game." Contemporary Physics 57.2 (2016): 151-163.


!!! warning "Dependencies"
    This method is enabled when the JuMP and GLPK packages are installed and loaded.

"""
function game(decisionMatrix::Matrix; verbose::Bool = false)::Array{GameResult,1}
    return game(Matrix(decisionMatrix), verbose = verbose)
end

function game(decisionMatrix::Matrix{<:Real}; verbose::Bool = false)::Array{GameResult,1}
    rowplayers_result = game_solver(decisionMatrix, verbose = verbose)
    columnplayers_result = game_solver(Matrix(decisionMatrix') * -1.0, verbose = verbose)
    return [rowplayers_result, columnplayers_result]
end

function game_solver(decisionMatrix::Matrix{<:Real}; verbose::Bool = false)::GameResult

    nrow, ncol = size(decisionMatrix)

    model = JuMP.Model(GLPK.Optimizer)
    JuMP.MOI.set(model, JuMP.MOI.Silent(), !verbose)


    JuMP.@variable(model, x[1:nrow])
    JuMP.@variable(model, g)
    JuMP.@objective(model, Max, g)

    for i = 1:ncol
        JuMP.@constraint(model, sum(x[1:nrow] .* decisionMatrix[:, i]) >= g)
    end

    for i = 1:nrow
        JuMP.@constraint(model, x[i] >= 0)
    end

    JuMP.@constraint(model, sum(x) == 1.0)

    if verbose
        @info model
    end

    JuMP.optimize!(model)

    values = JuMP.value.(x)

    gamevalue = JuMP.value(g) #objective_value(model)

    result = GameResult(values, gamevalue)

    return result

end

end # end of module game 
