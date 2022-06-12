using JMcDM

df = [
    GreyNumber(1, 2) GreyNumber(5, 8) GreyNumber(0, 3);
    GreyNumber(4, 5) GreyNumber(6, 7) GreyNumber(9, 10);
    GreyNumber(8, 9) GreyNumber(3, 4) GreyNumber(6, 7);
]

w = [0.50, 0.25, 0.25]
fns = makeminmax([maximum, maximum, maximum])
result = topsis(makeDecisionMatrix(df), w, fns)
@info result 

# ┌ Info: Scores:
# │ Any[GreyNumber(0.13192236905307952, 0.4891557063006889), 
#       GreyNumber(0.2003555029364691, 1.2935321688223387), 
#       GreyNumber(0.39986397310033467, 1.20680568791548)]
# │ Best indices:
# └ 3
