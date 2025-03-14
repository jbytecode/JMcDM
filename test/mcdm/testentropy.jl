@testset "Entropy" begin
    tol = 0.0001
    decmat = hcat(
        [2.0, 4, 3, 5, 4, 3],
        [1, 1, 2, 1, 2, 2],
        [4, 5, 6, 5, 5, 6],
        [7, 6, 6, 7, 6, 6],
        [6, 7, 5, 6, 7, 6],
        [6, 7, 6, 7, 7, 6],
        [7, 6, 8, 7, 6, 6],
        [3000, 3500, 4000, 3000, 3000, 3500],
    )

    result = entropy(decmat)

    @test result isa EntropyResult

    @test isapprox(
        result.w,
        [
            0.29967360960,
            0.44136733892,
            0.07009088720,
            0.02123823711,
            0.04902292895,
            0.02308037885,
            0.04776330969,
            0.04776330969,
        ],
        atol = tol,
    )

end