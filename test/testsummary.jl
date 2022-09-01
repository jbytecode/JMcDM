@testset "Summary" begin
    tol = 0.0001
    df = DataFrame(
        :c1 => [25.0, 21, 19, 22],
        :c2 => [65.0, 78, 53, 25],
        :c3 => [7.0, 6, 5, 2],
        :c4 => [20.0, 24, 33, 31],
    )
    weights = [0.25, 0.25, 0.25, 0.25]
    fns = [maximum, maximum, minimum, maximum]

    result1 = JMcDM.summary(df, weights, fns, [:topsis, :electre, :cocoso, :copras, :moora])
    result2 = JMcDM.summary(df, weights, fns, [:grey, :aras, :saw, :wpm, :waspas, :edas])
    result3 = JMcDM.summary(df, weights, fns, [:mabac, :mairca, :rov, :marcos, :vikor])

    @test result1 isa DataFrame
    @test result2 isa DataFrame
    @test result3 isa DataFrame

    @test size(result1) == (4, 5)
    @test size(result2) == (4, 6)
    @test size(result3) == (4, 5)
end
