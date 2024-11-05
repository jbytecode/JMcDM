@testset "ARAS" begin

    tol = 0.0001

    mat = hcat(
        [105000.0, 120000, 150000, 115000, 135000],
        [105.0, 110, 120, 105, 115],
        [10.0, 15, 12, 20, 15],
        [4.0, 4, 3, 4, 5],
        [300.0, 500, 550, 600, 400],
        [10.0, 8, 12, 9, 9],
    )
    functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

    w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

    result = aras(mat, w, functionlist)
    @test isa(result, ARASResult)
    @test isapprox(
        result.scores,
        [0.81424068, 0.89288620, 0.76415790, 0.84225462, 0.86540635],
        atol = tol,
    )
    @test result.bestIndex == 2

    setting = MCDMSetting(mat, w, functionlist)
    result2 = aras(setting)
    @test result2 isa ARASResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, ArasMethod())
    @test result3 isa ARASResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end