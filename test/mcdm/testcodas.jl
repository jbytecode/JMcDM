@testset "CODAS" begin
    tol = 0.0001
    decmat = [
        60.000 0.400 2540 500 990
        6.350 0.150 1016 3000 1041
        6.800 0.100 1727.2 1500 1676
        10.000 0.200 1000 2000 965
        2.500 0.100 560 500 915
        4.500 0.080 1016 350 508
        3.000 0.100 1778 1000 920
    ]


    w = [0.036, 0.192, 0.326, 0.326, 0.12]
    fns = [maximum, minimum, maximum, maximum, maximum]

    result = codas(decmat, w, fns)
    @test result isa CODASResult
    @test isapprox(
        result.scores,
        [
            0.512176491,
            1.463300035,
            1.07153259,
            -0.212467998,
            -1.851520552,
            -1.17167677,
            0.188656204,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, w, fns)
    result2 = codas(setting)
    @test result2 isa CODASResult
    @test result2.scores == result.scores

    result3 = mcdm(setting, CodasMethod())
    @test result3 isa CODASResult
    @test result3.scores == result.scores
end
