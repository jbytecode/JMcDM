### 0.7.16 (Upcoming Release)

- Remove legacy normalization in Waspas
- Add documentation for Grey Numbers
- Add citations to operations on Grey Numbers
- Binary comparison operators are redefined as in the citation given


### 0.7.15

- Export more inner state variables of critic method. 


### 0.7.14 

- Implement nullnormalization for disabling normalization

### 0.7.13

- Fix docstring of todim method (delete the special characters).

### 0.7.12 

- Implementation of TODIM method as a new MCDM tool.


### 0.7.11

- ARAS, EDAS, and WASPAS results are now holding more inner-calculation results.

### 0.7.10 

- Add LMAW (Logarithm Methodology of Additive Weights) as a new MCDM tool.
- add OCRA (Operational Competitiveness RAting)  a new MCDM tool.

### 0.7.9

- Add LOPCOW (LOgarithmic Percentage Change-driven Objective Weighting) method for automatic calculation of weights.


### 0.7.8

- Add normalization option to WPM method
- XYZMethod() now defines the default normalization for the possible copeland calls.
- Test code coverage increased.
- Added isfinite(), isnan(), one() for GreyNumber.
- Added simplify() for GreyNumber.

### 0.7.7

- Update documentation to method which takes optional normalization argument.
- Add optional normalization to SECA method.
- Add optional normalization to Moora ref and ratio methods.

### 0.7.6

- Remove Base.show methods of McDMResults. The structure is already readable enough.
- Custom normalization feed for other methods 


### 0.7.5
- Users can now manually feed a normalization method for any MCDM tool.
- Normalization parts of the methods separated as a new module. 


### 0.7.4 
- Topsis returns ideal vectors in TopsisResult structure


### 0.7.3

- Implement SECA method.
- Remove DataFrames dependency from tests and DataEnvelop
- DataEnvelop now works with dictionaries


### 0.7.2

- Remove redundant nds() method that takes a DataFrame argument.


### 0.7.1
- Remove redundant functions from Utility.jl after the dependency of DataFrames.jl was removed.
- Update README
- Update Jupyter notebook for example usage
- Reformat source code using JuliaFormatter


### 0.7.0 
- Remove dependency of DataFrames.jl. All of the functions now takes the decision matrix in type of Matrix.
  

### 0.6.0 
- Dependencies for JuMP and GLPK removed. Requires.jl automatically activates Game and DataEnvelop modules when these two packages are loaded manually by the user. 

### 0.5.7 
- Documentation for copeland
  

### 0.5.7
- Copeland with vector of methods implemented. With this implementation 

```julia
  met = [
    PIVMethod(),
    PSIMethod(),
    ROVMethod(),
    SawMethod(),
    VikorMethod(),
    WaspasMethod(),
    WPMMethod(),
]
result = copeland(df, w, fns, met)
```

type call is possible
  

### 0.5.6 
- Remove dependency of `makeminmax()`. Now functions take Vector{F} where {F <: Function}

### 0.5.5
- Report more result in JMcDMResults
- Add new methods to mcdm()
- Update documentation system and integrate with CI

### 0.5.4 
- More verbose Topsis output with distances to positive and negative ideal solutions.
  
### 0.5.3 
- Add tests for GreyNumber type
- methods now accept Matrix (in addition to DataFrame)
- PIV (Proximity Indexed Value) method implemented

### 0.5.2 
- Implement MEREC

### 0.5.1
- Grey Number support for more methods 


### 0.5.0
- game() now returns solution vector for both players
- mcdm() function receives TopsisMethod() as default argument
- yml file updates for testing
- Julia version is updated from ^1.4 to ^1.5
- minor fixes and new tests on mcdm methods
- Grey Numbers and their operations
- Grey Number support for Topsis, Vikor, Aras, Cocoso, Codas, Copras, Edas, Mabac 
- Grey Number support for Mairca, Marcos, Moosra, Waspas, Wpm, Saw, Rov, Psi
- Grey Number support for Moora, Electre
  
### 0.4.1
- Update documents for CRITIC method 
- Update mcdm()

### 0.4.0 
- Modular system

### 0.3.11 
- game() accepts matrix
- Implement MOOSRA method

### 0.3.10
- Fix game solver

### 0.3.9
- Implement PSI (Preference Selection Index) method

### 0.3.8
- Small bug fixes 
- Remove the critic method from summary()
- print and summary for ROV method


### 0.3.7 
- Add compat entry for new JuMP version 1.0.0
- Update README
  
### 0.3.6
- Fix Vikor 


### 0.3.5
- Update dependencies GLPK and JuMP

### 0.3.4 
- Add new tests for Copeland
- Documentation added for Copeland 
  
  
### 0.3.3
- ROV (Range of Value) Method implemented.

### 0.3.2
- SD method implemented for determining weights.

### 0.3.1
- fix Copeland.
- add Moora Ratio method with new tests.

### 0.3.0
- entropy() returns a result even though there are NaNs for some criterion.
- rwrapper.R added so the library is callable from within R
- copeland() method added for combining multiple ordering results.
  

### 0.2.9
- Default optimizer is now GLPK (Cbc removed)


### 0.2.8
- Direction of optimization added for nds()
- New tests added

### 0.2.7
- Bug in Moore fixed.
- Bug in Marcos fixed.


### 0.2.6
- Bug in Electre fixed.
- New tests added.
- Tests were divided into several files
- Dependencies upgraded


### 0.2.5
- On/Off switch for tests. 
- New tests.

### 0.2.4
- Base.show(io:IO, MCDMResult) implementations for pretty printing all of the results
- I() implemented, LinearAlgebra package removed from dependencies.
- mean(), geomean(), std(), and cor() are implemented and StatsBase & Statistics packages are removed
- using keyword replaced by import and only the needed functions are loaded at startup.
