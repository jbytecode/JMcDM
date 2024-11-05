@testset "TOPSIS" begin
    tol = 0.00001
    decmat = hcat(
        Float64[9, 8, 7],
        Float64[7, 7, 8],
        Float64[6, 9, 6],
        Float64[7, 6, 6])


    w = Float64[4, 2, 6, 8]

    fns = [maximum, maximum, maximum, maximum]

    result = topsis(decmat, w, fns)

    @test isa(result, TopsisResult)
    @test result.bestIndex == 2
    @test isapprox(result.scores, [0.3876870, 0.6503238, 0.0834767], atol = tol)

    setting = MCDMSetting(decmat, w, fns)
    result2 = topsis(setting)
    @test isa(result2, TopsisResult)
    @test result2.bestIndex == result.bestIndex
    @test result.scores == result2.scores

    result3 = mcdm(setting, TopsisMethod())
    @test isa(result3, TopsisResult)
    @test result3.bestIndex == result.bestIndex
    @test result3.scores == result.scores
end
