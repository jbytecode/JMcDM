module Seca

import ..MCDMMethod, ..MCDMResult
using Statistics
using JuMP
using Ipopt

struct SecaMethod <: MCDMMethod end

struct SecaResult <: MCDMResult
  decisionMatrix::Matrix
  weights::Vector{Float64}
  scores::Vector
  ranks::Vector
end

"""
    seca(df::Matrix, fns::Vector{Function}, beta::Float64; epsilon::Float64=10^-3)

Implement the SECA method for multi-criteria decision making.

# Arguments
- `df::Matrix`: A matrix of decision criteria.
- `fns::Vector{Function}`: A vector of functions that specifies the Beneficial Criteria (BC) as `maximum` and the non-Beneficial Criteria (NC) as `minimum`.
- `beta::Float64`: This coefficient affects the importance of reaching the reference points of criteria weights.
- `epsilon::Float64=10^-3`: a small positive parameter considered as a lower bound for
criteria weights.

# Description
seca implements the SECA method for multi-criteria decision making and finds the weights of the criteria simultaneously with evaluating the alternatives. The model is based on maximization of the overall performance of alternatives with consideration of the variation information of decision-matrix within and between criteria. seca returns a `SecaResult` object that contains the decision matrix, weights, scores, and ranks.

# Returns
- `SecaResult`: A `SecaResult` object that contains the decision matrix, weights, scores, and ranks.

# Example
```julia
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
```

# Reference
- [Simultaneous Evaluation of Criteria and Alternatives (SECA) for Multi-Criteria Decision-Making](http://dx.doi.org/10.15388/Informatica.2018.167)
"""
function seca(df::Matrix, fns::Vector{Function}, beta::Float64; epsilon::Float64=10^-3)
  @assert beta≥0 "beta should be greater than or equal to zero."
  @assert length(fns) == size(df, 2) "The number of functions should be equal to the number of criteria in the decision matrix."

  β = beta
  ϵ = epsilon
  n, m =  size(df)

  # Amatrix construction
  Amat = similar(df)
  max_idx, min_idx = fns .== maximum, fns .== minimum
  # Normalize the decision matrix based on the concept of BC and NC
  Amat[:, max_idx] .= df[:, max_idx]./maximum(df[:, max_idx])
  Amat[:, min_idx] .= minimum(df[:, min_idx])./df[:, min_idx]

  # Calculate σᴺ and πᴺ
  σⱼ = map(eachcol(Amat)) do col
    std(col)
  end

  σᴺ::Vector = σⱼ ./ sum(σⱼ)

  r::Matrix = cor(mat, dims=1)

  πⱼ::Vector = vec(sum(-r.+1, dims=1))

  πᴺ::Vector = πⱼ ./ sum(πⱼ)

  # ======= Optimization Model =======
  model = Model(Ipopt.Optimizer)

  # ======= Variables =======
  @variables(model, begin
    ϵ <= w[i=1:m] <= 1
  end)

  @variable(model, λₐ)
  @variable(model, λb)
  @variable(model, λc)

  Sᵢ = sum(w[i]*mat[:, i] for i=1:m)

  # ======= Constraints =======
  @constraint(model,
  λb == sum((w[j]*σᴺ[j])^2 for j=1:m)
  )

  @constraint(model,
    λc == sum((w[j]*πᴺ[j])^2 for j=1:m)
  )

  @constraint(model, λₐ.<=Sᵢ)

  @constraint(model,
    sum(w[i] for i=1:m) == 1
  )
  # ======= Objective =======
  @NLobjective(model, Max, λₐ-β*(λb + λc))
  set_silent(model)
  optimize!(model)
  weights = value.(w)

  # Calculate overall performance score and ranks of alternatives
  scores = sum(weights[i]*mat[:, i] for i=1:m)
  ranks = abs.(invperm(sortperm(scores)).-(n+1))

  SecaResult(Amat, weights, scores, ranks)
end;
end # module Seca
