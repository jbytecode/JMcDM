# JMcDM
A package for Multiple-criteria decision making techniques in Julia


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



