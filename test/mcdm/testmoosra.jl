@testset "MOOSRA" begin
    tol = 0.0001

    decmat = hcat(
        [25.0, 21, 19, 22],
        [65.0, 78, 53, 25],
        [7.0, 6, 5, 2],
        [20.0, 24, 33, 31],
    )
    weights = [0.25, 0.25, 0.25, 0.25]
    fns = [maximum, maximum, minimum, maximum]
    result = moosra(decmat, weights, fns)

    @test result isa MoosraResult

    @test isapprox(
        result.scores,
        [15.714285714285714, 20.499999999999996, 20.999999999999996, 39.0],
        atol = tol,
    )

    @test result.rankings == [1, 2, 3, 4]
    @test result.bestIndex == 4

    setting = MCDMSetting(decmat, weights, fns)
    result2 = mcdm(setting, MoosraMethod())
    @test result2.bestIndex == result.bestIndex
    @test result2.scores == result.scores
    @test result2 isa MoosraResult
end
