function dataenvelop(input::Array{Float64,2}, output::Array{Float64,1}; verbose::Bool=false)::DataEnvelopResult

    nrow, ncol = size(input)

    efficiencies = zeros(Float64, nrow)
    resultdf = DataFrame()
    casenames::Array{Symbol,1} = []
    
    for objectnum in 1:nrow

        model = Model(Cbc.Optimizer);
        MOI.set(model, MOI.Silent(), !verbose)

        @variable(model, x[1:nrow])
        @variable(model, theta)

        @objective(model, Min, theta)
    
        for varnum in 1:ncol
            @constraint(model, sum(input[:, varnum] .* x[1:nrow]) - input[objectnum, varnum] * theta <= 0)
        end
        @constraint(model, sum(output .* x[1:nrow]) - output[objectnum] >= 0)

        @constraint(model, theta >= 0)
        for i in 1:nrow
            @constraint(model, x[i] >= 0)
        end

        optimize!(model)

        values = JuMP.value.(x)
        theta = objective_value(model)

        efficiencies[objectnum] = theta 
        push!(casenames,  Symbol(string("Case", objectnum)))
        resultdf[:, casenames[objectnum]] = values[1:nrow]
    end

    orderedEfficiencyIndex = sortperm(efficiencies, ) |> reverse
    orderedCases = casenames[orderedEfficiencyIndex]

    result = DataEnvelopResult(
        efficiencies,
        resultdf,
        orderedCases
    )

    return result
end