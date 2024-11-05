@testset "TODIM" begin
    tol = 0.0001
    decisionMat = [
        10 11 12
        7 8 9
        4 5 6
        1 2 3
    ]
    weights = fill(1 / 3, 3)
    fns = [maximum, maximum, maximum]

    result = todim(decisionMat, weights, fns)
    @test result isa TODIMResult
    @test isapprox(
        result.scores,
        [
            1.0,
            0.75,
            0.375,
            0.0,
        ],
        atol = tol,
    )

    # Including minimum function
    fns = [maximum, maximum, minimum]
    result2 = todim(decisionMat, weights, fns)
    @test result2 isa TODIMResult

end