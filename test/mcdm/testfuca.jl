@testset "FUCA" begin
    decisionMat = [
         315.0 110.0 300.0 205.0 38.5 2.2 0.005 2016.0
         600.0 300.0 350.0 305.0 28.0 3.7 0.005 2016.0
         600.0 300.0 350.0 305.0 28.0 3.7 0.005 1998.0
         600.0 400.0 380.0 305.0 28.0 3.7 0.005 1992.0
         315.0 110.0 300.0 205.0 38.5 2.2 0.005 2002.0
         315.0 110.0 300.0 205.0 38.5 2.2 0.002 2009.0
         500.0 200.0 350.0 205.0 31.5 3.7 0.005 2009.0
         510.0 205.0 355.0 205.0 31.5 3.7 0.005 2014.0
        1280.0 550.0 600.0 510.0 53.5 3.4 0.002 2017.0
         600.0 500.0 400.0 355.0 37.0 3.7 0.002 2018.0
        1600.0 720.0 650.0 510.0 53.5 4.2 0.002 2014.0
         510.0 205.0 355.0 205.0 31.5 3.7 0.005 2016.0
    ]
    weights = fill(0.125, 8)
    dirs = [maximum, maximum, maximum, maximum, maximum, maximum, minimum, maximum]

    result = fuca(decisionMat, weights, dirs)
    # Table 13 assigns M2 a non-average C3 tie rank. The ranks below are
    # calculated from Table 12, where M2, M3, and M7 all have C3 = 350.
    expectedScores = [8.75, 6.4375, 7.3125, 6.75, 9.5, 8.5625, 8.1875, 7.25, 2.8125, 3.5, 2.0, 6.9375]

    @test result isa FUCAResult
    @test result.scores == expectedScores
    @test result.ranking == [11, 9, 10, 2, 4, 12, 8, 3, 7, 6, 1, 5]
    @test result.ranks == [11, 4, 8, 5, 12, 10, 9, 7, 2, 3, 1, 6]
    @test result.bestIndex == 11
    @test isapprox(result.rankMatrix[1, :], [11, 11, 11, 9.5, 4, 11, 8.5, 4])

    setting = MCDMSetting(decisionMat, weights, dirs)
    settingResult = fuca(setting)
    methodResult = mcdm(setting, FucaMethod())
    @test settingResult.scores == result.scores
    @test methodResult.ranking == result.ranking
end
