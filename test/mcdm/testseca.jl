@testset "SECA" begin
    tol = 0.00001
    decmat = hcat(
        Float64[9, 8, 7],
        Float64[7, 7, 8],
        Float64[6, 9, 6],
        Float64[7, 6, 6])

    beta = 0.5
    fns = [maximum, maximum, maximum, maximum]

    result = seca(decmat, fns, beta)

    @test isa(result, SECAResult)
    @test result.bestIndex == 1
    @test isapprox(result.scores, [0.86004480, 0.83316666, 0.83316666], atol = tol)
end