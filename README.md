[![DOI](https://joss.theoj.org/papers/10.21105/joss.03430/status.svg)](https://doi.org/10.21105/joss.03430)

# JMcDM
A package for Multiple-criteria decision-making techniques in Julia.

## The problem

Suppose a decision process has n alternatives and m criteria  which are either to be maximized or minimized. Each single criterion has a weight _0 ≤ wᵢ ≤ 1_ where sum of _wᵢ_ is 1. _fᵢ_ is either maximum or minimum. _gⱼ(.)_ is the evolution function and it is choosen as _gⱼ(x) = x_ in many methods. A multiple criteria decision problem can be represented using the decision table 

<img src="https://github.com/jbytecode/JMcDM/blob/gh-pages/images/generalformula.png" width = "50%"/>

<!--
   | **Criteria**  |   C_1    |   C_2    |  ...  |   C_m    |
   | :-----------: | :------: | :------: | :---: | :------: |
   |  **Weights**  |   w_1    |   w_2    |  ...  |   w_m    |
   | **Functions** |   f_1    |   f_2    |  ...  |   f_m    |
   |      A_1      | g_1(A_1) | g_2(A_1) |  ...  | g_m(S_A) |
   |      A_2      | g_1(A_2) | g_2(A_2) |  ...  | g_m(A_2) |
   |       ⋮       |    ⋮     |    ⋮     |  ...  |    ⋮     |
   |      A_n      | g_1(A_n) | g_2(A_n) |  ...  | g_m(A_n) |
-->

without loss of generality. When _A₁, A₂, ..., Aₙ_ are alternatives and _C₁, C₂, ..., Cₙ_ are different situations of a single criterion then the decision problem is said to be single criterion decision problem. If _Cⱼ_ are strategies of two game players then _gⱼ(Aᵢ)_ is the gain of the row player when she selects the strategy _i_ and the column player selects the strategy _Cⱼ_.


The package mainly focuses on solving these kinds of decision problems.

## For whom?

Multiple-criteria decision-making is an inter-discipline subject and there is a vast amount of research in the literature in this area. However, the existing software packages in this area are generally focused on a small subset of tools. JMcDM is a developer and researcher-friendly Julia package that combines the developed methods, utility functions for implementing new ones, and serves an environment for comparing results of multiple analyses.  

## Installation

Please type 

```julia
julia> ]
(@v1.7) pkg> add JMcDM
```

or

```julia
julia> using Pkg
julia> Pkg.add("JMcDM")
```

in Julia REPL. 


## Package Dependencies

Since the Julia package manager installs all of the dependencies automatically, a standard user doesn't need to
install them manually. The package dependencies are listed below:

- DataFrames
- GLPK
- JuMP


## Documentation

Please check out the reference manual [here](https://jbytecode.github.io/JMcDM/docs/build/).


## Implemented methods

### MCDM Tools

- TOPSIS (Technique for Order Preference by Similarity to Ideal Solutions)
- ELECTRE (Elimination and Choice Translating Reality)
- DEMATEL (The Decision Making Trial and Evaluation Laboratory)
- MOORA Reference (Multi-Objective Optimization By Ratio Analysis)
- MOORA Ratio
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
- Copeland (For combining multiple ordering results)
- SD Method for determining weights of criteria
- ROV (Range of Value) Method
- PSI (Preference Selection Index) Method

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
- SWARA
- ORESTE
- SMAA
- TODIM

- will be updated soon. 

## Example

```julia
julia> using JMcDM
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

alternatively

```julia
julia> result = mcdm(df, w, fns, TopsisMethod())
```

or 

```julia
julia> setting = MCDMSetting(df, w, fns)
julia> result = topsis(setting)
```

or

```julia
julia> setting = MCDMSetting(df, w, fns)
julia> result = mcdm(setting, TopsisMethod())
```

### Jupyter Notebook

Here is a Jupyter Notebook for basic usage: 

https://github.com/jbytecode/JMcDM/blob/main/notebook/basic-usage.ipynb


## Community guidelines

### How to cite 

Please use the BibTeX entry:

```bibtex
@article{Satman2021,
  doi = {10.21105/joss.03430},
  url = {https://doi.org/10.21105/joss.03430},
  year = {2021},
  publisher = {The Open Journal},
  volume = {6},
  number = {65},
  pages = {3430},
  author = {Mehmet Hakan Satman and Bahadır Fatih Yıldırım and Ersagun Kuruca},
  title = {JMcDM: A Julia package for multiple-criteria decision-making tools},
  journal = {Journal of Open Source Software}
}
```

or citation string

Satman et al., (2021). JMcDM: A Julia package for multiple-criteria decision-making tools. Journal of Open Source Software, 6(65), 3430, https://doi.org/10.21105/joss.03430

to cite this software.

### Contribute to software
Do you want to contribute?

- Please create an issue first. In this issue, please specify the idea.
- Let the community discuss the new contribution in our Slack channel or the created issue.

If the community decision is yes, please

- Fork the repository
- Add the new code to this forked repository
- Make sure the tests are passed 
- Send a pull request with a good description of functionality.

### Where to start?
The TOPSIS method, defined in [topsis.jl](https://github.com/jbytecode/JMcDM/blob/main/src/topsis.jl), is a basis for many methods and it can be followed before implementing a new one. 

### The design pattern
- ```topsis()``` takes the decision matrix, weights, and vector of directions of optimization as arguments. This function is defined in ```topsis.jl```.

```julia
   function topsis(decisionMat::DataFrame, weights::Array{Float64,1}, fns::Array{Function,1})::TopsisResult
```

- ```topsis()``` method has a return type of ```TopsisResult```. This ```struct``` is defined in ```types.jl```

```julia
  struct TopsisResult <: MCDMResult
    decisionMatrix::DataFrame
    weights::Array{Float64,1}
    normalizedDecisionMatrix::DataFrame
    normalizedWeightedDecisionMatrix::DataFrame 
    bestIndex::Int64 
    scores::Array{Float64,1}
end
```

- Optionally, a ```show``` function can be derived for pretty-printing the result. These functions are defined in ```print.jl```

```julia
function Base.show(io::IO, result::TopsisResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end
```

Please read the issue [Welcome to newcomers!](https://github.com/jbytecode/JMcDM/issues/3) for other implementation details.

### Report Issues

If you find a bug or error, first report the problem in a new issue. If the problem is already addressed
in an existing issue please follow the existing one.

### Seek Support
Our Slack channel is [JMcDM Slack Channel](https://julialang.slack.com/archives/C01MJ0VF1U3). Please feel free to ask about any problem using our Slack channel or issues. [Julia Discourse](https://discourse.julialang.org/t/jmcdm-a-julia-package-for-multiple-criteria-decision-making-tools/54942) is the JMcDM entry in Julia Discourse site and any thoughts, problems, and issues can also be discussed there.


Welcome!
