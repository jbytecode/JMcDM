@testset "WPM" begin
    tol = 0.0001
    decmat = [
        3 12.5 2 120 14 3
        5 15 3 110 38 4
        3 13 2 120 19 3
        4 14 2 100 31 4
        3 15 1.5 125 40 4
    ]

    weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

    fns = [maximum, minimum, minimum, maximum, minimum, maximum]

    result = wpm(decmat, weights, fns)
    @test result isa WPMResult
    @test isapprox(
        result.scores,
        [
            0.7975224331331,
            0.7532541470585,
            0.7647463553356,
            0.7873956894791,
            0.7674278741782,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, fns)
    result2 = wpm(setting)
    @test result2 isa WPMResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, WPMMethod())
    @test result3 isa MCDMResult
    @test result3 isa WPMResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end