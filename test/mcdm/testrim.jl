@testset "RIM" begin
    tol = 0.00001
    decisionMat = [
        30.0 0.0 2.0 3.0 3.0 2.0
        40.0 9.0 1.0 3.0 2.0 2.0
        25.0 0.0 3.0 1.0 3.0 2.0
        27.0 0.0 5.0 3.0 3.0 1.0
        45.0 15.0 2.0 2.0 3.0 4.0
    ]
    weights = [0.2262, 0.2143, 0.1786, 0.1429, 0.1190, 0.1190]
    ranges = [(23.0, 60.0), (0.0, 15.0), (0.0, 10.0),
              (1.0, 3.0), (1.0, 3.0), (1.0, 5.0)]
    referenceIdeals = [(30.0, 35.0), (10.0, 15.0), (0.0, 0.0),
                       (3.0, 3.0), (3.0, 3.0), (4.0, 5.0)]

    result = rim(decisionMat, weights, ranges, referenceIdeals)
    @test result isa RIMResult
    @test result.bestIndex == 2
    @test result.ranking == [2, 5, 1, 4, 3]
    @test isapprox(result.normalizedDecisionMatrix, [
        1.0 0.0 0.8 1.0 1.0 1 / 3
        0.8 0.9 0.9 1.0 0.5 1 / 3
        2 / 7 0.0 0.7 0.0 1.0 1 / 3
        4 / 7 0.0 0.5 1.0 1.0 0.0
        0.6 1.0 0.8 0.5 1.0 1.0
    ], atol=tol)
    @test isapprox(result.weightedNormalizedDecisionMatrix, [
        0.22620 0.0 0.14288 0.14290 0.11900 0.03967
        0.18096 0.19287 0.16074 0.14290 0.05950 0.03967
        0.06463 0.0 0.12502 0.0 0.11900 0.03967
        0.12926 0.0 0.08930 0.14290 0.11900 0.0
        0.13572 0.21430 0.14288 0.07145 0.11900 0.11900
    ], atol=tol)
    @test isapprox(result.distanceToIdeal, [0.23129, 0.11251, 0.31877, 0.27831, 0.12070], atol=tol)
    # Tables 6, 8, and 11 conflict with equation (3) and the published
    # weighted matrix; these values follow the paper's stated equations.
    @test isapprox(result.distanceToOrigin, [0.32823, 0.34831, 0.18852, 0.24344, 0.34378], atol=tol)
    @test isapprox(result.scores, [0.58663, 0.75584, 0.37163, 0.46658, 0.74015], atol=tol)

    setting = MCDMSetting(decisionMat, weights, fill(maximum, length(weights)))
    result2 = rim(setting, ranges, referenceIdeals)
    result3 = mcdm(setting, RimMethod(ranges, referenceIdeals))
    result4 = mcdm(decisionMat, weights, setting.fns, RimMethod(ranges, referenceIdeals))
    @test isapprox(result2.scores, result.scores, atol=tol)
    @test isapprox(result3.scores, result.scores, atol=tol)
    @test isapprox(result4.scores, result.scores, atol=tol)

    sensitivityWeights = [
        weights .* [0.9, 1.0, 1.0, 1.0, 1.0, 1.0],
        weights .* [0.9, 1.1, 1.0, 1.0, 1.0, 1.0],
        weights .* [0.9, 1.1, 1.0, 1.0, 0.9, 1.0],
        weights .* [0.9, 1.2, 1.0, 1.0, 1.0, 1.0],
        weights .* [0.85, 1.15, 1.0, 1.0, 1.0, 1.0],
        weights .* [0.9, 0.9, 1.0, 1.0, 1.2, 1.0],
    ]
    expectedSensitivityScores = [
        [0.57512, 0.75386, 0.37484, 0.46264, 0.74803],
        [0.55475, 0.75919, 0.36376, 0.44776, 0.75557],
        [0.55131, 0.76377, 0.35449, 0.44169, 0.75354],
        [0.53558, 0.76452, 0.35287, 0.43338, 0.76302],
        [0.53922, 0.76110, 0.35945, 0.43838, 0.76331],
        [0.60411, 0.73850, 0.40571, 0.49105, 0.74596],
    ]
    for (sensitivityWeights, expectedScores) in zip(sensitivityWeights, expectedSensitivityScores)
        @test isapprox(rim(decisionMat, sensitivityWeights, ranges, referenceIdeals).scores,
                       expectedScores, atol=tol)
    end

    decisionMatWithH = vcat(decisionMat, [32.0 8.0 1.0 3.0 3.0 3.0])
    resultWithH = rim(decisionMatWithH, weights, ranges, referenceIdeals)
    @test isapprox(resultWithH.normalizedDecisionMatrix[end, :], [1.0, 0.8, 0.9, 1.0, 1.0, 2 / 3], atol=tol)
    @test isapprox(resultWithH.weightedNormalizedDecisionMatrix[end, :],
                   [0.2262, 0.1714, 0.1607, 0.1429, 0.1190, 0.0793], atol=0.0001)
    @test isapprox(resultWithH.distanceToIdeal[end], 0.06107, atol=tol)
    @test isapprox(resultWithH.distanceToOrigin[end], 0.38376, atol=tol)
    @test isapprox(resultWithH.scores[end], 0.86271, atol=tol)
    @test resultWithH.ranking == [6, 2, 5, 1, 4, 3]
    @test isapprox(resultWithH.scores[1:5], result.scores, atol=tol)

    @test_throws ErrorException rim(decisionMat, weights[1:5], ranges, referenceIdeals)
    @test_throws ErrorException rim(decisionMat, weights, ranges, [(30.0, 35.0)])
    @test_throws ErrorException rim(decisionMat, weights, [(60.0, 23.0); ranges[2:end]], referenceIdeals)
end
