function game(decisionMatrix::DataFrame; verbose=false)::GameResult
    
    newDecisionMatrix = similar(decisionMatrix)
    
    nrow, ncol = size(decisionMatrix)

    minmat = minimum(decisionMatrix)
    modified = false

    if minmat < 0
        modified = true
        newDecisionMatrix = decisionMatrix .- minmat    
    end

    dm = convert(Matrix, newDecisionMatrix)

    model = Model(Cbc.Optimizer);
    MOI.set(model, MOI.Silent(), !verbose)


    @variable(model, x[1:nrow])
    @objective(model, Min, sum(x))

    for i in 1:nrow
        @constraint(model, sum(x[1:nrow] .* dm[:, i]) >= 1)
    end

    for i in 1:nrow
        @constraint(model, x[i] >= 0)
    end

    optimize!(model);

    values = JuMP.value.(x)

    gamevalue = 1 / objective_value(model)
    p = gamevalue * values
    
    if modified
        gamevalue -= abs(minmat)
    end

    result = GameResult(
        p,
        gamevalue
    )
    
    return result
end