@testset "PSI" begin
    tol = 0.0001

    decmat = hcat(
        Float64[9, 8, 7],
        Float64[7, 7, 8],
        Float64[6, 9, 6],
        Float64[7, 6, 6])

    w = Float64[4, 2, 6, 8]

    fns = [maximum, maximum, maximum, maximum]

    result = psi(decmat, fns)

    @test result isa PSIResult
    @test result.bestIndex == 2
    @test isapprox(
        [1.1487059780663555, 1.252775986851622, 1.0884916686098811],
        result.scores,
        atol = tol,
    )

    setting = MCDMSetting(decmat, w, fns)
    result2 = mcdm(setting, PSIMethod())
    @test result2.bestIndex == result.bestIndex
    @test result2.scores == result.scores
    @test result2 isa PSIResult
end
