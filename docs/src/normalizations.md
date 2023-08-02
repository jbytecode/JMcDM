# Normalization Methods for MCDM

In MCDM methods, e.g. topsis, aras, waspas, each single method has a predefined and default
normalization method. However the normalization method can be specifically defined by setting
the normalization= parameter in MCDM functions.

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

## Divide by Column Maximum-Minimum Normalization
```@docs
JMcDM.Normalization.dividebycolumnmaxminnormalization
```

## Inverse Divide by Column Maximum-Minimum Normalization
```@docs
JMcDM.Normalization.inversedividebycolumnmaxminnormalization
```

## Divide by All Norm Normalization
```@docs
JMcDM.Normalizations.dividebyallnormnormalization
```


