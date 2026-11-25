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
        [2.2725788177322643, 2.815245881568694, 3.1745836984778255, 6.833640474697763],
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

@testset "MOOSRA published example: Adali and Isik (2017), Table 10" begin
    # Laptop selection, J Ind Eng Int 13:229-237, doi:10.1007/s40092-016-0175-5
    decmat = [
        3.5 6 1256 4 16 3 17.3 8 2.82 4100
        3.1 4 1000 2 8 1 15.6 5 3.08 3800
        3.6 6 2000 4 16 3 17.3 5 2.9 4000
        3.0 4 1000 2 8 2 17.3 5 2.6 3500
        3.3 6 1008 4 12 3 15.6 8 2.3 3800
        3.6 6 1000 2 16 3 15.6 5 2.8 4000
        3.5 6 1256 2 16 1 15.6 6 2.9 4000
    ]
    weights = [0.297, 0.025, 0.035, 0.076, 0.154, 0.053, 0.104, 0.017, 0.025, 0.214]
    fns = [fill(maximum, 8); minimum; minimum]
    result = moosra(decmat, weights, fns)
    @test all(isapprox.(result.scores, [3.382, 2.509, 3.533, 2.860, 3.343, 3.184, 3.001], atol = 0.0006))
    @test result.bestIndex == 3
end
