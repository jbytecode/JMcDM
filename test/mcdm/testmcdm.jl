@testset "mcdm() with default method" begin
    tol = 0.00001

    mat = hcat(
        Float64[9, 8, 7],
        Float64[7, 7, 8],
        Float64[6, 9, 6],
        Float64[7, 6, 6])

    w = Float64[4, 2, 6, 8]

    fns = [maximum, maximum, maximum, maximum]


    result = topsis(mat, w, fns)

    setting = MCDMSetting(mat, w, fns)
    result2 = mcdm(setting)

    @test isa(result2, TopsisResult)
    @test result2.bestIndex == result.bestIndex
    @test result2.scores == result.scores
end