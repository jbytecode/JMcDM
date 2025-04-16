module SECA

import ..MCDMMethod, ..MCDMResult, ..MCDMSetting
import ..Normalizations

using ..Utilities

using ..JuMP, ..Ipopt

export seca, SECAResult, SECAMethod

struct SECAMethod <: MCDMMethod 
    normalization::G where {G <: Function}
end

SECAMethod() = SECAMethod(Normalizations.groupeddividebymaxminnormalization)

struct SECAResult <: MCDMResult
    decisionMatrix::Matrix
    weights::Array{Float64,1}
    scores::Vector
    ranking::Array{Int64,1}
    bestIndex::Int64
end



"""
    seca(decisionMat, fns:, beta; epsilon, normalization)

Implement the SECA method for multi-criteria decision making.

# Arguments
- `decisionMat::Matrix`: A matrix of decision criteria.
- `fns::Array{F,1}`: A vector of functions that specifies the Beneficial Criteria (BC) as `maximum` and the non-Beneficial Criteria (NC) as `minimum`.
- `beta::Float64`: This coefficient affects the importance of reaching the reference points of criteria weights. Note that the output of model is dependent on the value of beta. It's recommended to try several values until you barely see any change in the weights of each criterion.
- `epsilon::Float64 = 10^-3`: a small positive parameter considered as a lower bound for criteria weights.
- `normalization{<:Function}`: Optional normalization function.

# Description
seca implements the SECA method for multi-criteria decision making and finds the weights
of the criteria simultaneously with evaluating the alternatives. The model is based on
maximization of the overall performance of alternatives with consideration of the
variation information of decision-matrix within and between criteria. seca returns a
`SecaResult` object that contains the decision matrix, weights, scores, and ranks.

# Returns
- `SECAResult`: A `SECAResult` object that contains the decision matrix, weights, scores, and ranks.

# Example
```julia
julia> using JuMP, Ipopt, JMcDM
julia> mat = [
           1.0     0.9925  0.9115  0.8     0.9401  1.0     0.9449;
           0.8696  0.8271  0.8462  1.0     0.9181  0.978   1.0;
           0.7391  0.8684  0.7615  0.2667  0.8177  0.8241  0.8305;
           0.5217  0.7895  0.6654  0.2     0.8051  0.7236  0.8061;
           0.6522  0.9135  0.7692  0.2857  0.8396  0.7063  0.8812;
           0.6087  0.8346  0.7269  0.3077  0.8722  0.6742  0.8926;
           0.913   0.985   0.9346  0.6667  0.9813  0.8641  0.9216;
           0.8696  0.9624  1.0     0.5714  0.9632  0.7807  0.9751;
           0.8261  1.0     0.8077  0.6667  1.0     0.7946  0.9104;
           0.3478  0.8195  0.7462  0.3636  0.8263  0.6642  0.814
       ];

julia> fns = [maximum, minimum, minimum, minimum, minimum, minimum, minimum];

julia> seca(mat, fns, 0.5)
Scores:
[0.5495915719484191, 0.467758585220479, 0.7430581528101969, 0.805136683615562, 0.6786410609782462, 0.6314963009852793, 0.5445938440469921, 0.5570359821894877, 0.509907132860776, 0.4677585801615632]
Ordering:
[6, 9, 2, 1, 3, 4, 7, 5, 8, 10]
Best indice:
4
```

# Reference

- [Simultaneous Evaluation of Criteria and Alternatives (SECA) for Multi-Criteria Decision-Making](http://dx.doi.org/10.15388/Informatica.2018.167)

!!! warning "Dependencies"
    This method is enabled when the JuMP and Ipopt packages are installed and loaded.

"""
function seca(
    decisionMat::Matrix,
    fns::Array{F,1},
    beta::Float64;
    epsilon::Float64 = 10^-3,
    normalization::G = Normalizations.groupeddividebymaxminnormalization
)::SECAResult where {F<:Function, G<:Function}

    @assert beta ≥ 0 "beta should be greater than or equal to zero."
    @assert length(fns) == size(decisionMat, 2) "The number of functions should be equal to the number of criteria in the decision matrix."

    β = beta
    ϵ = epsilon
    n, m = size(decisionMat)


    Amat = normalization(decisionMat, fns)


    # Calculate σᴺ and πᴺ
    σⱼ = map(eachcol(Amat)) do col
        std(col)
    end

    σᴺ::Vector = σⱼ ./ sum(σⱼ)

    r::Matrix = cor(Amat)

    πⱼ::Vector = vec(sum(-r .+ 1, dims = 1))

    πᴺ::Vector = πⱼ ./ sum(πⱼ)

    # ======= Optimization Model =======
    model = Model(Ipopt.Optimizer)

    # ======= Variables =======
    @variables(model, begin
        ϵ <= w[i = 1:m] <= 1
    end)

    @variable(model, λₐ)
    @variable(model, λb)
    @variable(model, λc)

    Sᵢ = sum(w[i] * Amat[:, i] for i = 1:m)

    # ======= Constraints =======
    @constraint(model, λb == sum((w[j] * σᴺ[j])^2 for j = 1:m))

    @constraint(model, λc == sum((w[j] * πᴺ[j])^2 for j = 1:m))

    @constraint(model, λₐ .<= Sᵢ)

    @constraint(model, sum(w[i] for i = 1:m) == 1)
    # ======= Objective =======
    @NLobjective(model, Max, λₐ - β * (λb + λc))
    set_silent(model)
    optimize!(model)
    weights = value.(w)

    # Calculate overall performance score and ranks of alternatives
    scores = sum(weights[i] * Amat[:, i] for i = 1:m)
    ranks = abs.(invperm(sortperm(scores)) .- (n + 1))

    SECAResult(Amat, weights, scores, ranks, argmax(scores))
end

end # module Seca
