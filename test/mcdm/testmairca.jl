@testset "MAIRCA" begin

    tol = 0.0001
    decmat = [
        6.952 8.000 6.649 7.268 8.000 7.652 6.316
        7.319 7.319 6.604 7.319 8.000 7.652 5.313
        7.000 7.319 7.652 6.952 7.652 6.952 4.642
        7.319 6.952 6.649 7.319 7.652 6.649 5.000
    ]


    weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140]

    fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum]

    result = mairca(decmat, weights, fns)
    @test result isa MAIRCAResult
    @test isapprox(
        result.scores,
        [0.1206454, 0.0806646, 0.1458627, 0.1454237],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, fns)
    result2 = mairca(setting)
    @test result2 isa MAIRCAResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, MaircaMethod())
    @test result3 isa MAIRCAResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end