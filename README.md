# JMcDM
A package for Multiple-criteria decision making techniques in Julia.

# The problem

Suppose a decision process has $n$ alternatives and $m$ criteria  which are either to be maximized or minimized. Each single criterion has a weight $0 <= w_i <= 1$ where sum of w_i is 1. f_i is either maximum or minimum. g_j(.) is evolution function and it is taken as g_j(x) = x in many methods. A multiple criteria decision problem can be represented using the decision table 

   | **Criteria**  |   C_1    |   C_2    | ...  |   C_m    |
   | :-----------: | :--------: | :--------: | :------: | :--------: |
   |  **Weights**  |   w_1    |    w_2     | ...      |   w_m     |
   | **Functions** |   f_1    |    f_2     | ...      |   f_m     |
   |     A_1     | g_1(A_1)   |  g_2(A_1)  | ...      |  g_m(S_A)  |
   |     A_2     | g_1(A_2)   |  g_2(A_2)  | ...      |  g_m(A_2)  |
   |       ⋮       |     ⋮     |     ⋮      | ...      |     ⋮      |
   |     A_n     | g_1(A_n)   |  g_2(A_n)  | ...      |  g_m(A_n)  |

without loss of generality. When A_1, A_2, ..., A_n are alternatives and C_1, C_2, ..., C_m are different situations of a single criterion then the decision problem is said to be single criterion decision problem. If A_i and C_j are strategies of two game players then g_j(A_i) is the gain of the row player when she selects the strategy *i* and the column player selects the strategy C_j. 


The package mainly focused on solving these kind of decision problems.


## Installation

Please type 

```julia
julia> ]
(@v1.5) pkg> add JMcDM
```

or

```julia
julia> using Pkg
julia> Pkg.add("JMcDM")
```

in Julia REPL.

## Documentation

Please check out the reference manual [here](https://jbytecode.github.io/JMcDM/docs/build/).


## Implemented methods

### MCDM Tools

- TOPSIS (Technique for Order Preference by Similarity to Ideal Solutions)
- ELECTRE (Elemination and Choice Translating Reality)
- DEMATEL (The Decision Making Trial and Evaluation Laboratory)
- MOORA (Multi-Objective Optimization By Ratio Analysis)
- VIKOR (VlseKriterijumska Optimizcija I Kaompromisno Resenje in Serbian)
- AHP (Analytic Hierarchy Process)
- DEA (Data Envelopment Analysis)
- GRA (Grey Relational Analysis)
- Non-dominated Sorting 
- SAW (Simple Additive Weighting) (aka WSM)
- ARAS (Additive Ratio Assessment)
- WPM (Weighted Product Model)
- WASPAS (Weighted Aggregated Sum Product ASsessment)
- EDAS (Evaluation based on Distance from Average Solution)
- MARCOS (Measurement Alternatives and Ranking according to COmpromise Solution)
- MABAC (Multi-Attributive Border Approximation area Comparison)
- MAIRCA (Multi Attributive Ideal-Real Comparative Analysis)
- COPRAS (COmplex PRoportional ASsessment)
- PROMETHEE (Preference Ranking Organization METHod for Enrichment of Evaluations)
- CoCoSo (Combined Compromise Solution)
- CRITIC (CRiteria Importance Through Intercriteria Correlation)
- Entropy
- CODAS (COmbinative Distance-based ASsessment)

### SCDM Tools

- minimax
- maximin
- minimin
- maximax
- Savage
- Hurwicz
- MLE
- Laplace
- Expected Regret

### Game

- Game solver for zero sum games


## Unimplemented methods
- UTA
- MAUT
- STEM
- PAPRIKA
- ANP (Analytical Network Process)
- Goal Programming
- MACBETH
- COMET

- will be updated soon. 

## Example

```julia
julia> using JMcDM, DataFrames
julia> df = DataFrame(
:age        => [6.0, 4, 12],
:size       => [140.0, 90, 140],
:price      => [150000.0, 100000, 75000],
:distance   => [950.0, 1500, 550],
:population => [1500.0, 2000, 1100]);
```


```julia
julia> df
3×5 DataFrame
 Row │ age      size     price     distance  population 
     │ Float64  Float64  Float64   Float64   Float64    
─────┼──────────────────────────────────────────────────
   1 │     6.0    140.0  150000.0     950.0      1500.0
   2 │     4.0     90.0  100000.0    1500.0      2000.0
   3 │    12.0    140.0   75000.0     550.0      1100.0
```


```julia
julia> w  = [0.35, 0.15, 0.25, 0.20, 0.05];
julia> fns = makeminmax([minimum, maximum, minimum, minimum, maximum]);
julia> result = topsis(df, w, fns);
julia> result.scores
3-element Array{Float64,1}:
0.5854753145549456
0.6517997936899308
0.41850223305822903

julia> result.bestIndex
2
```


## Community guidelines

Do you want to contribute?

- Please create an Issue first. In this issue, please specify the idea.
- Let the community discuss the new contribution.

If the community decision is yes, please


- Fork the repository
- Send a pull request.

Please read the issue [Welcome to newcomers!](https://github.com/jbytecode/JMcDM/issues/3) for implementation details.

Welcome!
