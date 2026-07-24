@testset "SPOTIS" begin
    tol = 0.0002

    # Example extracted from "The SPOTIS Rank Reversal Free Method" (Example 2, car selection).
    decmat = [
        15000.0 4.3 99.0 42.0 737.0
        15290.0 5.0 116.0 42.0 892.0
        15350.0 5.0 114.0 45.0 952.0
        15490.0 5.3 123.0 45.0 1120.0
    ]

    # Importance values [5, 4, 4, 1, 3] normalized internally by the method.
    raw_weights = [5.0, 4.0, 4.0, 1.0, 3.0]
    weights = raw_weights ./ sum(raw_weights)

    # C1, C2, C3 are cost criteria. C4, C5 are benefit criteria.
    dirs = [minimum, minimum, minimum, maximum, maximum]

    lowerbounds = [14000.0, 3.0, 80.0, 35.0, 650.0]
    upperbounds = [16000.0, 8.0, 140.0, 60.0, 1300.0]

    result = spotis(decmat, weights, dirs, lowerbounds=lowerbounds, upperbounds=upperbounds)

    @test result isa SPOTISResult
    @test isapprox(result.scores, [0.4779, 0.5781, 0.5558, 0.5801], atol = tol)
    @test result.ranking == [1, 3, 2, 4]
    @test result.bestIndex == 1

    setting = MCDMSetting(decmat, weights, dirs)
    result2 = spotis(setting, lowerbounds=lowerbounds, upperbounds=upperbounds)

    @test result2 isa SPOTISResult
    @test result2.bestIndex == result.bestIndex
    @test result2.ranking == result.ranking
    @test isapprox(result2.scores, result.scores, atol = tol)

    method = SpotisMethod(lowerbounds, upperbounds)
    result3 = mcdm(setting, method)

    @test result3 isa SPOTISResult
    @test result3.bestIndex == result.bestIndex
    @test result3.ranking == result.ranking
    @test isapprox(result3.scores, result.scores, atol = tol)
end
