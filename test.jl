using JMcDM


df = DataFrame(
    :c1 => [1.0, 2, 3, 4],
    :c2 => [5.0, 6, 7, 8],
    :c3 => [10.0, 11, 12, 13],
    :c4 => [20.0, 30, 40, 360],
)
weights = [0.25, 0.25, 0.25, 0.25]
fns = [maximum, maximum, maximum, maximum]

met = [
    PIVMethod(),
    PSIMethod(),
    ROVMethod(),
    SawMethod(),
    VikorMethod(),
    WaspasMethod(),
    WPMMethod(),
]

result = copeland(df, w, fns, met)
