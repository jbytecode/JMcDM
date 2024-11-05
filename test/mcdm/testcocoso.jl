@testset "CoCoSo" begin
    tol = 0.0001
    decmat = [
        60.00 0.40 2540.00 500.00 990.00
        6.35 0.15 1016.00 3000.00 1041.00
        6.80 0.10 1727.20 1500.00 1676.00
        10.00 0.20 1000.00 2000.00 965.00
        2.50 0.10 560.00 500.00 915.00
        4.50 0.08 1016.00 350.00 508.00
        3.00 0.10 1778.00 1000.00 920.00
    ]


    weights = [0.036, 0.192, 0.326, 0.326, 0.120]

    lambda = 0.5

    fns = [maximum, minimum, maximum, maximum, maximum]

    result = cocoso(decmat, weights, fns, lambda = lambda)
    @test result isa CoCoSoResult
    @test isapprox(
        result.scores,
        [
            2.0413128390265998,
            2.787989783418825,
            2.8823497955972495,
            2.4160457689259287,
            1.2986918936013303,
            1.4431429073391682,
            2.519094173200623,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, fns)
    result2 = cocoso(setting)
    @test result2 isa CoCoSoResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, CocosoMethod())
    @test result3 isa CoCoSoResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end