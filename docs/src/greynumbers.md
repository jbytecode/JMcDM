# Multiple-criteria Decision Making Tools with Grey Numbers 


## A grey number

```julia
julia> a = GreyNumber(1, 4)
GreyNumber(1, 4)

julia> b = GreyNumber(2, 8)
GreyNumber(2, 8)

julia> a + b
GreyNumber(3, 12)

julia> a - b
GreyNumber(-7, 2)

julia> a * b
GreyNumber(2, 32)

julia> 10 * a 
GreyNumber(10, 40)

julia> b / 10
GreyNumber(0.2, 0.8)

julia> a < b
true

julia> a > b
false

julia> a * -1
GreyNumber(-4, -1)
```


## whitenize
```@docs
JMcDM.whitenizate
```


## kernel
```@docs
JMcDM.kernel
```

# MCDM Tools with Grey Numbers 

## Grey Topsis

```julia
decmat = [
    GreyNumber(1.0, 2.0) GreyNumber(2.0, 3.0) GreyNumber(3.0, 4.0);
    GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0) GreyNumber(3.0, 4.0);
    GreyNumber(3.0, 4.0) GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0)
    ]

w = [0.5, 0.4, 0.1]
fns = [maximum, maximum, minimum]

result = topsis(decmat, w, fns)
scores = result.scores

# 3-element Vector{Any}:
#  GreyNumber(0.2350699228751952, 0.83613099715003)
#  GreyNumber(0.24317523558639148, 1.002942207810138)
#  GreyNumber(0.10851899761349458, 1.23913068959885) 
```

## Other tools

Since the required arithmetic operators and logical operators are implemented for the Grey Number type, all of the MCDM methods perform in the same way as their real-valued counterparts. So 

```julia
mcdm_method(decmat, weights, fns)
```

is applicable for `mcdm_method` can be topsis, waspas, edas, copras, etc. 

### References 

- Liu, S., Fang, Z., Yang, Y., & Forrest, J. (2012). General grey numbers and their operations. Grey Systems: Theory and Application, 2(3), 341-349.

- Bhunia, Asoke Kumar, and Subhra Sankha Samanta. "A study of interval metric and its application in multi-objective optimization with interval objectives." Computers & Industrial Engineering 74 (2014): 169-178.
