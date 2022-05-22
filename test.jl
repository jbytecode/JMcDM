using JMcDM
using DataFrames




df = DataFrame()
df[:, :x] = Float64[9, 8, 7]
df[:, :y] = Float64[7, 7, 8]
df[:, :z] = Float64[6, 9, 6]
df[:, :q] = Float64[7, 6, 6]
w = Float64[4, 2, 6, 8]

fns = makeminmax([maximum, maximum, maximum, maximum])

result = psi(df, fns)


