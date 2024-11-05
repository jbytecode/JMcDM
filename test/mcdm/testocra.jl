@testset "OCRA" begin
    tol = 0.0001
    decisionMat = [
        8.0 16.0 1.5 1.2 4200.0 5.0 5.0 314.0 185.0;
        8.0 16.0 1.0 1.3 4200.0 5.0 4.0 360.0 156.0;
        10.1 16.0 2.0 1.3 4060.0 5.0 3.0 503.0 160.0;
        10.1 8.0 1.0 1.5 5070.0 2.0 4.0 525.0 200.0;
        10.0 16.0 2.0 1.2 6350.0 5.0 3.0 560.0 190.0;
        10.1 16.0 1.0 1.2 5500.0 2.0 2.0 521.0 159.0;
        10.1 64.0 2.0 1.7 5240.0 5.0 3.0 770.0 199.0;
        7.0 32.0 1.0 1.8 3000.0 3.0 4.0 364.0 157.0;
        10.1 16.0 1.0 1.3 3540.0 5.0 3.0 510.0 171.0;
        9.7 16.0 2.0 1.83 7500.0 6.0 2.0 550.0 170.0
    ]
    fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum, minimum]
    weights = [0.167, 0.039, 0.247, 0.247, 0.116, 0.02, 0.056, 0.027, 0.081]

    result = ocra(decisionMat, weights, fns)
    @test result isa OCRAResult
    @test isapprox(
        result.scores,
        [
            0.1439209390821490,
            0.0241065507104361,
            0.2734201159562310,
            0.0429791654417769,
            0.3185195380415760,
            0.0024882426914911,
            0.5921715172301160,
            0.1139028947061430,
            0.0000000000000000,
            0.4787485498471800,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decisionMat, weights, fns)
    result2 = ocra(setting)
    @test result2 isa OCRAResult
    @test result2.scores == result.scores
end