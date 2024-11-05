@testset "EDAS" begin
    tol = 0.0001
    decmat = [
        5000 5 5300 450.0
        4500 5 5000 400
        4500 4 4700 400
        4000 4 4200 400
        5000 4 7100 500
        5000 5 5400 450
        5500 5 6200 500
        5000 4 5800 450
    ]

    weights = [0.25, 0.25, 0.25, 0.25]

    fns = [maximum, maximum, minimum, minimum]

    result = edas(decmat, weights, fns)
    @test result isa EDASResult
    @test isapprox(
        result.scores,
        [
            0.759594,
            0.886016,
            0.697472,
            0.739658,
            0.059083,
            0.731833,
            0.641691,
            0.385194,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, fns)
    result2 = edas(setting)
    @test result2 isa EDASResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, EdasMethod())
    @test result3 isa EDASResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end