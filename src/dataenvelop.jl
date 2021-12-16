"""
        dataenvelop(input, output; verbose = false)

Apply data envelop analysis for a given input matrix and an output vector.


# Arguments:
 - `input::Array{Float,2}`: n × m matrix of input values. 
 - `output::Array{Float64, 1}`: n-vector of output values.
 - `verbose::Bool`: Logical value indicating whether to show optimizition logs. Default is false.

# Description 
dataenvloper() applies the data envelop analysis to calculate efficiencies of cases.

# Output 
- `::DataEnvelopResult`: DataEnvelopResult object that holds many results including efficiencies and rankings.

# Examples
```julia-repl
julia> x1 = [96.0, 84, 90, 81, 102, 83, 108, 99, 95];
julia> x2 = [300.0, 282, 273, 270, 309, 285, 294, 288, 306];
julia> out = [166.0, 150, 140, 136, 171, 144, 172, 170, 165];
julia> inp = hcat(x1, x2);
julia> result = dataenvelop(inp, out);
julia> result.orderedcases
9-element Array{Symbol,1}:
 :Case8
 :Case2
 :Case7
 :Case1
 :Case9
 :Case6
 :Case5
 :Case4
 :Case3

julia> result.efficiencies
9-element Array{Float64,1}:
 0.9879815986198964
 0.9999999999999999
 0.8959653733189055
 0.9421686746987951
 0.9659435120753173
 0.9715662650602411
 0.9911164465786314
 1.0
 0.9841048789857857
```

# References
İşletmeciler, Mühendisler ve Yöneticiler için Operasyonel, Yönetsel ve Stratejik Problemlerin
Çözümünde Çok Kriterli Karar verme Yöntemleri, Editörler: Bahadır Fatih Yıldırım ve Emrah Önder,
Dora, 2. Basım, 2015, ISBN: 978-605-9929-44-8
"""
function dataenvelop(input::Array{Float64,2}, output::Array{Float64,1}; verbose::Bool=false)::DataEnvelopResult

    nrow, ncol = size(input)

    efficiencies = zeros(Float64, nrow)
    resultdf = DataFrame()
    casenames::Array{Symbol,1} = []
    
    for objectnum in 1:nrow

        model = Model(GLPK.Optimizer);
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