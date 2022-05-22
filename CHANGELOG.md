### 0.3.11 (upcoming release)
- game() accepts matrix

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
