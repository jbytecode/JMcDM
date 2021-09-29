---
title: 'JMcDM: A Julia package for multiple-criteria decision-making tools'
tags:
  - Julia
  - decision making
  - multiple criteria
  - outranking
authors:
  - name: Mehmet Hakan Satman
    orcid: 0000-0002-9402-1982
    affiliation: 1
  - name: Bahadır Fatih Yıldırım
    orcid: 0000-0002-0475-741X
    affiliation: 2
  - name: Ersagun Kuruca
    orcid: 0000-0002-2552-7701
    affiliation: 3
affiliations:
 - name: Department of Econometrics, Istanbul University, Istanbul, Turkey
   index: 1
 - name: Department of Transportation and Logistics, Istanbul University, Istanbul, Turkey
   index: 2
 - name: Independent researcher
   index: 3


date: 8 May 2021
bibliography: paper.bib
---

# Summary
```JMcDM``` is a ```Julia``` package that implements some leading multiple-criteria decision-making tools for both researchers and developers. By having a REPL tool, ```Julia``` is well suited for researchers to perform their analysis using different methods and comparing their results. ```JMcDM``` also provides the necessary infrastructure, utility functions, and a standardized API for implementing recently published methods.  The package brings MCDM (Multiple-Criteria Decision-Making) tools to a relatively new language such as ```Julia``` with its significant performance promises. Besides Julia being a new language, the methods developed in the package are designed to be familiar to users who previously used the ```R``` and ```Python``` languages. This paper presents the basics of the design, example usage, and code snippets.

# Introduction
The one-dimensional array $a$ is in ascending order if and only if $a_i \le a_{i+1}$ where $i = 1, 2, \dots, n-1$, and $n$ is the length of the array. In other terms, the process of ordering numbers requires the logical $\le$ operator to be perfectly defined. Since the operator $\le$ is not defined for any set of points in higher dimensions, $\mathbb{R}^p$ for $p \ge 2$, there is not a unique ordering of points. In the multi-dimensional case, the binary domination operator $\succ$ applied on points $a$ and $b$, $a \succ b$, is true if each item in $a$ is not worse than the corresponding item in $b$ and at least one item is better than the corresponding item in $b$ [@Deb_2002]. On the other hand, the more relaxed operator $\succeq$ returns true if each item in $a$ is as good as the corresponding item in $b$ [@greco2016multiple]. Several outranking methods in MCDM (Multiple-Criteria Decision Making) define a unique ranking mechanism to select the best alternative among others.

Suppose a decision process has $n$ alternatives and $m$ criteria that are either to be maximized or minimized. Each single criterion has a weight $0 \le w_i \le 1$ where $\sum_i^m w_i = 1$ and is represented by a function $f_i$ which is either maximum or minimum. $g_j(.)$ is an evolution function and it is taken as $g_j(x) = x$ in many methods. A multiple criteria decision problem can be represented using the decision table shown in Table \ref{decision_table} without loss of generality. When $A_1$, $A_2$, $\dots$, $A_n$ are alternatives and $C_1$, $C_2$, $\dots$, $C_m$ are different situations of a single criterion then the decision problem is said to be a single criterion decision problem. If $A_i$ and $C_j$ are strategies of two game players then $g_j(A_i)$ is the gain of the row player when she selects the strategy $i$ and the column player selects the strategy $C_j$. 

Table: Decision table \label{decision_table}

| **Criteria**  |   $C_1$    |   $C_2$    | $\dots$  |   $C_m$    |
| :-----------: | :--------: | :--------: | :------: | :--------: |
|  **Weights**  |   $w_1$    |   $w_2$    | $\dots$  |   $w_m$    |
| **Functions** |   $f_1$    |   $f_2$    | $\dots$  |   $f_m$    |
|     $A_1$     | $g_1(A_1)$ | $g_2(A_1)$ | $\dots$  | $g_m(S_A)$ |
|     $A_2$     | $g_1(A_2)$ | $g_2(A_2)$ | $\dots$  | $g_m(A_2)$ |
|       ⋮       |     ⋮      |     ⋮      | $\ddots$  |     ⋮      |
|     $A_n$     | $g_1(A_n)$ | $g_2(A_n)$ | $\dots$  | $g_m(A_n)$ |


# State of the field

Multiple-criteria decision-making (MCDM) tools provide several algorithms for ordering or  selecting alternatives and/or determining the weights when there is uncertainty. Although some algorithms are suitable for hand calculations, computer software is often required. While some previous applications only focused on a single method, some applications appear to include multiple methods. ```PyTOPS``` is a Python tool for TOPSIS [@PyTOPS]. ```Super Decisions``` is a software package that is mainly focused on AHP (Analytic Hierarchy Process) and ANP (Analytic Network Process) [@superdecision]. ```Visual Promethee``` implements the Promethee method on Windows platforms [@visualpromethee]. ```M-BACBETH``` is another commercial software product that implements MACBETH with an easy to use GUI [@macbeth]. ```Sanna``` is a standard ```MS Excel``` add-in application that supports several basic methods for multi-criteria evaluation of alternatives (WSA, TOPSIS, ELECTRE I and III, PROMETHEE I and II, MAPPAC and ORESTE) [@sanna]. The ```DEAFrontier``` software requires an ```Excel``` add-in that can solve up to 50 DMUs with unlimited number of inputs and outputs (subject to the capacity of the standard ```MS Excel Solver```) [@deafrontier]. 



# Statement of need 

While the applications mentioned above are lacking in features such as the number of methods included, being programmable, being free, and the results being comparable by the researcher, ```JMcDM``` clearly differs as it has all of these features.
```JMcDM``` is designed to provide a developer-friendly library for solving multiple-criteria decision problems in ```Julia``` [@julia]. Since ```Julia``` is a dynamic language, it is also useful for researchers who are familiar with REPL (Read-Eval-Print-Loop) environments. The package includes multi-criteria decision methods as well as a game solver for zero-sum games, and methods for single criterion methods. 

The package implements methods for 
AHP [@ahp],
ARAS [@aras],
COCOSO [@cocoso],
CODAS [@codas],
COPRAS [@copras], 
CRITIC [@critic],
DEMATEL [@dematel], 
EDAS [@edas], 
ELECTRE [@electre], 
Entropy [@entropy],
GRA [@gra], 
MABAC [@mabac], 
MAIRCA [@mairca], 
MARCOS [@marcos], 
MOORA [@moora], 
NDS [@Deb_2002], 
PROMETHEE [@promethee], 
SAW [@saw; @wsm_wpm],  
TOPSIS [@topsis],
VIKOR [@vikor_1; @vikor_2],  
WASPAS [@waspas], 
and
WPM [@wsm_wpm]
for multiple-criteria tools. This list of selected methods includes both classical (TOPSIS, ELECTRE, PROMETHEE, etc.) and modern (COCOSO, MABAC, MARCOS, etc.) tools of the relevant literature. 

The package also performs Data Envelopment Analysis (DEA) [@dea] and includes a method for solving zero-sum games. Although these methods may seem different from the methods mentioned above, they are basically members of the same method family and solve similar problems. DEA differs from the above methods in that it is not an outranking method but compares efficiencies of decision units. Solving zero-sum games is also a multi-criteria decision-making problem, but this time, unlike outranking methods, both the rows and columns of the decision matrix show alternative strategies. 

The full set of other tools and utility functions are listed and documented in the source code as well as in the online documentation.

# Installation and basic usage

`JMcDM` can be downloaded and installed using the Julia package manager by typing

```julia
julia> using Pkg
julia> Pkg.add("JMcDM")
```

and can be loaded before using any functions by typing

```julia
julia> using JMcDM
```

in ```Julia``` REPL.

Suppose a decision problem is given in the table below.

| **Criteria**  |  Age   |  Size  |  Price   | Distance | Population |
| :-----------: | :----: | :----: | :------: | :------: | :--------: |
|  **Weights**  | $0.35$ | $0.15$ |  $0.25$  |  $0.20$  |   $0.05$   |
| **Functions** |  min   |  max   |   min    |   min    |    max     |
|     $A_1$     |  $6$   | $140$  | $150000$ |  $950$   |   $1500$   |
|     $A_2$     |  $4$   |  $90$  | $100000$ |  $1500$  |   $2000$   |
|     $A_3$     |  $12$  | $140$  | $75000$  |  $550$   |   $1100$   |

In this sample problem, a decision maker is subject to select an apartment by considering the age of the building, size (in $m^2$s), price (in \$), distance to city centre (in $m$s), and nearby population.
The data can be entered as a two-dimensional array (matrix) or as a DataFrame object:

```julia
julia> using JMcDM
julia> df = DataFrame(
:age        => [6.0, 4, 12],
:size       => [140.0, 90, 140],
:price      => [150000.0, 100000, 75000],
:distance   => [950.0, 1500, 550],
:population => [1500.0, 2000, 1100]);
```
The weight vector ```w```, vector of directions ```fns```, and ```topsis()``` function call can be performed using the ```Julia``` REPL.

```julia
julia> w  = [0.35, 0.15, 0.25, 0.20, 0.05];
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

In the output above, it is shown that the alternative $A_2$ has a score of $0.65179$ and it is selected as the best. The same analysis can be performed using ```saw()``` for the method of Simple Additive Weighting

```julia
julia> result = saw(df, w, fns);
julia> result.bestIndex
2
```

as well as using ```wpm``` for the method of Weighted Product Method 

```julia
julia> result = wpm(df, w, fns);
julia> result.bestIndex
2
```

For any method, ```?methodname``` shows the documentation as in the same way in other ```Julia``` packages.

# References
