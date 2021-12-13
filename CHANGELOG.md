### Next revision
- Tests were divided into several files
- Dependencies upgraded

### 0.2.6
- Bug in Electre fixed.
- New tests added.
  
### 0.2.5
- On/Off switch for tests. 
- New tests.

### 0.2.4
- Base.show(io:IO, MCDMResult) implementations for pretty printing all of the results
- I() implemented, LinearAlgebra package removed from dependencies.
- mean(), geomean(), std(), and cor() are implemented and StatsBase & Statistics packages are removed
- using keyword replaced by import and only the needed functions are loaded at startup.
