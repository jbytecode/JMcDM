using JMcDM

df = [
    GreyNumber(1, 2) GreyNumber(5, 8) GreyNumber(0, 3);
    GreyNumber(4, 5) GreyNumber(6, 7) GreyNumber(9, 10);
    GreyNumber(8, 9) GreyNumber(3, 4) GreyNumber(6, 7);
]

w = [0.50, 0.25, 0.25]

fns = makeminmax([maximum, maximum, maximum])


result = critic(makeDecisionMatrix(df), fns)
@info result 

