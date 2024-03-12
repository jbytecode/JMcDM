# Normalization Methods for MCDM

In MCDM methods, e.g. topsis, aras, waspas, each single method has a predefined and default
normalization method. However the normalization method can be specifically defined by setting
the normalization= parameter in MCDM functions. 

For example the default Topsis call with Vector norm normalization is

```julia
topsis(data, weights, fns)
```

whereas, the same method can be called with a different normalization method like 

```julia
topsis(data, weights, fns, normalization = Normalizations.dividebycolumnsumnormalization
```

## Vector Norm Normalization
```@docs 
JMcDM.Normalizations.vectornormnormalization
```

## Divide by Column Sums Normalization
```@docs
JMcDM.Normalizations.dividebycolumnsumnormalization
```

## Max-Min Range Normalization
```@docs
JMcDM.Normalizations.maxminrangenormalization
```

## Inverse Max-Min Range Normalization (max->min, min->max)
```@docs 
JMcDM.Normalizations.inversemaxminrangenormalization
```

## Grouped Max-Min Range Normalization
```@docs
JMcDM.Normalizations.groupeddividebymaxminnormalization
```

## Divide by Column Maximum-Minimum Normalization
```@docs
JMcDM.Normalizations.dividebycolumnmaxminnormalization
```

## Inverse Divide by Column Maximum-Minimum Normalization
```@docs
JMcDM.Normalizations.inversedividebycolumnmaxminnormalization
```

## Divide by All Norm Normalization
```@docs
JMcDM.Normalizations.dividebyallnormnormalization
```

## Null Normalization
```@docs
JMcDM.Normalizations.nullnormalization
```




