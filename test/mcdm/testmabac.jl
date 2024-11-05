@testset "MABAC" begin

    tol = 0.0001
    decmat = [
        2 1 4 7 6 6 7 3000.0
        4 1 5 6 7 7 6 3500
        3 2 6 6 5 6 8 4000
        5 1 5 7 6 7 7 3000
        4 2 5 6 7 7 6 3000
        3 2 6 6 6 6 6 3500
    ]


    weights = [0.293, 0.427, 0.067, 0.027, 0.053, 0.027, 0.053, 0.053]

    fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum]

    result = mabac(decmat, weights, fns)
    @test result isa MABACResult
    @test isapprox(
        result.scores,
        [-0.31132, -0.10898, 0.20035, 0.04218, 0.34452, 0.20035],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, fns)
    result2 = mabac(setting)
    @test result2 isa MABACResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, MabacMethod())
    @test result3 isa MABACResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end