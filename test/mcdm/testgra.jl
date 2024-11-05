@testset "Grey Relational Analysis" begin

    tol = 0.0001

    decmat = hcat(
        [105000.0, 120000, 150000, 115000, 135000],
        [105.0, 110, 120, 105, 115],
        [10.0, 15, 12, 20, 15],
        [4.0, 4, 3, 4, 5],
        [300.0, 500, 550, 600, 400],
        [10.0, 8, 12, 9, 9],
    )
    functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

    w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

    result = grey(decmat, w, functionlist)

    @test isa(result, GreyResult)

    @test isapprox(
        result.scores,
        [
            0.525,
            0.7007142857142857,
            0.5464285714285715,
            0.5762820512820512,
            0.650952380952381,
        ],
        atol = tol,
    )

    @test result.bestIndex == 2

    setting = MCDMSetting(decmat, w, functionlist)
    result2 = grey(setting)
    @test result2 isa GreyResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, GreyMethod())
    @test result3 isa GreyResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end
