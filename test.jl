using JMcDM
using DataFrames

dmat = [0.0 -1 1; 1 0 -1; -1 1 0]
df = makeDecisionMatrix(dmat)

g = game(df)
@info g 


