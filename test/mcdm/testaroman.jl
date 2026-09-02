@testset "AROMAN" begin
    tol = 0.0001

    decisionMat = [
        40000.0 1200.0 1.4 8.0 9.0
        38500.0 1150.0 1.2 6.0 6.0
        39400.0 600.0 1.1 7.0 5.0
        48000.0 1300.0 1.6 10.0 12.0
    ]
    weights = [0.28, 0.22, 0.26, 0.15, 0.09]
    fns = [minimum, maximum, maximum, maximum, maximum]

    result = aroman(decisionMat, weights, fns)

    @test result isa AROMANResult
    @test isapprox(
        result.linearNormalizedMatrix,
        [
            0.1579 0.8571 0.6000 0.5000 0.5714
            0.0000 0.7857 0.2000 0.0000 0.1429
            0.0947 0.0000 0.0000 0.2500 0.0000
            1.0000 1.0000 1.0000 1.0000 1.0000
        ],
        atol=tol,
    )
    @test all(isapprox.(
        result.vectorNormalizedMatrix,
        [
            0.4802 0.5470 0.5228 0.5070 0.5322
            0.4622 0.5242 0.4481 0.3802 0.3548
            0.4730 0.2735 0.4108 0.4436 0.2957
            0.5762 0.5926 0.5975 0.6337 0.7096
        ],
        atol=tol,
    ))
    @test all(isapprox.(
        result.aggregatedNormalizedMatrix,
        [
            0.1595 0.3510 0.2807 0.2517 0.2759
            0.1155 0.3275 0.1620 0.0951 0.1244
            0.1419 0.0684 0.1027 0.1734 0.0739
            0.3941 0.3981 0.3994 0.4084 0.4274
        ],
        atol=tol,
    ))
    @test all(isapprox.(
        result.weightedNormalizedMatrix,
        [
            0.0447 0.0772 0.0730 0.0378 0.0248
            0.0324 0.0720 0.0421 0.0143 0.0112
            0.0397 0.0150 0.0267 0.0260 0.0067
            0.1103 0.0876 0.1038 0.0613 0.0385
        ],
        atol=tol,
    ))
    @test isapprox(result.minimumSums, [0.0447, 0.0324, 0.0397, 0.1103], atol=tol)
    @test isapprox(result.maximumSums, [0.2128, 0.1396, 0.0744, 0.2912], atol=tol)
    @test isapprox(result.scores, [0.6727, 0.5535, 0.4721, 0.8718], atol=tol)
    @test result.ranking == [3, 2, 1, 4]
    @test result.bestIndex == 4

    setting = MCDMSetting(decisionMat, weights, fns)
    result2 = aroman(setting)
    @test result2 isa AROMANResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, AROMANMethod())
    @test result3 isa AROMANResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex

    customResult = aroman(setting, beta=0.3, lambda=0.2)
    dispatchedCustomResult = mcdm(setting, AROMANMethod(0.3, 0.2))
    @test dispatchedCustomResult.scores == customResult.scores
end
