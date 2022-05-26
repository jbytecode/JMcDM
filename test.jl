using JMcDM

df = DataFrame(
                :c1 => [25.0, 21, 19, 22],
                :c2 => [65.0, 78, 53, 25],
                :c3 => [7.0, 6, 5, 2],
                :c4 => [20.0, 24, 33, 31],
            )
weights = [0.25, 0.25, 0.25, 0.25]
fns = [maximum, maximum, minimum, maximum]
result = topsis(df, weights, fns)

print(result)
