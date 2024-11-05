@testset "MARCOS" begin
    tol = 0.0001
    decmat = [
        8.675 8.433 8.000 7.800 8.025 8.043
        8.825 8.600 7.420 7.463 7.825 8.229
        8.325 7.600 8.040 7.700 7.925 7.600
        8.525 8.667 7.180 7.375 7.750 8.071
    ]


    weights = [0.19019, 0.15915, 0.19819, 0.19019, 0.15115, 0.11111]

    fns = [maximum, maximum, maximum, maximum, maximum, maximum]

    Fns = convert(Array{Function, 1}, fns)

    result = marcos(decmat, weights, Fns)
    @test result isa MarcosResult
    @test isapprox(
        result.scores,
        [0.684865943528, 0.672767106696, 0.662596906139, 0.661103207660],
        atol = tol,
    )

    setting = MCDMSetting(decmat, weights, Fns)
    result2 = marcos(setting)
    @test result2 isa MarcosResult
    @test result2.scores == result.scores
    @test result2.bestIndex == result.bestIndex

    result3 = mcdm(setting, MarcosMethod())
    @test result3 isa MarcosResult
    @test result3.scores == result.scores
    @test result3.bestIndex == result.bestIndex
end