using JMcDM

df = DataFrame(
	:age        => [6.0, 4, 12],
	:size       => [140.0, 90, 140],
    :price      => [150000.0, 100000, 75000],
    :distance   => [950.0, 1500, 550],
    :population => [1500.0, 2000, 1100])

w  = [0.35, 0.15, 0.25, 0.20, 0.05]

fns = [minimum, maximum, minimum, minimum, maximum]

result = topsis(df, w, fns)




