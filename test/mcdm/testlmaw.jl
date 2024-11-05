@testset "LMAW" begin
    tol = 0.0001
    decisionMat = [
        647.34 6.24 49.87 19.46 212.58 6.75;
        115.64 3.24 16.26 9.69 207.59 3.00;
        373.61 5.00 26.43 12.00 184.62 3.74;
        37.63 2.48 2.85 9.25 142.50 3.24;
        858.01 4.74 62.85 45.96 267.95 4.00;
        222.92 3.00 19.24 21.46 221.38 3.49
    ]
    weights = [0.215, 0.126, 0.152, 0.091, 0.19, 0.226]
    fns = [maximum, maximum, minimum, minimum, minimum, maximum]

    result = lmaw(decisionMat, weights, fns)
    @test result isa LMAWResult
    @test isapprox(
        result.scores,
        [
            4.839005264308832,
            4.679718180594332,
            4.797731427991642,
            4.732145373983716,
            4.73416833375772,
            4.702247270959649,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decisionMat, weights, fns)
    result2 = lmaw(setting)
    @test result2 isa LMAWResult
    @test result2.scores == result.scores
end