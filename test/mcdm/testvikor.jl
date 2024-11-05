@testset "VIKOR" begin
    tol = 0.01
    w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
    Amat = [
        100 92 10 2 80 70 95 80.0
        80 70 8 4 100 80 80 90
        90 85 5 0 75 95 70 70
        70 88 20 18 60 90 95 85
    ]
    fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]

    result = vikor(Amat, w, fns)

    @test isa(result, VikorResult)
    @test result.bestIndex == 4

    @test isapprox(result.scores[1], 0.74, atol = tol)
    @test isapprox(result.scores[2], 0.73, atol = tol)
    @test isapprox(result.scores[3], 1.0, atol = tol)
    @test isapprox(result.scores[4], 0.0, atol = tol)

    setting = MCDMSetting(Amat, w, fns)
    result2 = vikor(setting)
    @test result.scores == result2.scores
    @test result.bestIndex == result2.bestIndex

    result3 = mcdm(setting, VikorMethod())
    @test result.scores == result3.scores
    @test result.bestIndex == result3.bestIndex
end