@testset "Fuzzy Topsis -(Nihan, T. C.(2011))" verbose = true begin

    """
    References:

    Nihan, T. C.(2011). Fuzzy Topsis Methods in Group Decision Making And An Application 
    For Bank Branch Location Selection. Journal of Engineering and Natural Sciences, 
    Sigma, 29, 11-24.
    """
    atol = 0.01

    dm1 = [
        Triangular(7.7, 9.3, 9.7) Triangular(7.3, 8.7, 9.3) Triangular(7.3, 8.7, 9.3) Triangular(7.3, 8.7, 9.3) Triangular(7.3, 8.7, 9.3)
        Triangular(7.3, 8.7, 9.3) Triangular(5.3, 6.5, 7.7) Triangular(7.7, 9.3, 9.7) Triangular(6.3, 7.5, 8.67) Triangular(6.3, 7.5, 8.67)
        Triangular(5.7, 7, 8.3) Triangular(5, 6.5, 8) Triangular(5.7, 7, 8.3) Triangular(5.67, 7, 8.3) Triangular(5.67, 7, 8.3)
        Triangular(7, 8, 9) Triangular(5, 6.5, 8) Triangular(5.7, 7, 8.3) Triangular(5.67, 7, 8.3) Triangular(5.67, 7, 8.3)
        Triangular(5, 6.5, 8) Triangular(3.3, 4.5, 5.7) Triangular(4.7, 6, 7.3) Triangular(4, 5, 6) Triangular(4.3, 5.5, 6.7)
    ]

    dm2 = [
        Triangular(7, 9.33, 10) Triangular(7, 8.67, 10) Triangular(5, 7.83, 10) Triangular(7, 8.67, 10) Triangular(7, 8.67, 10)
        Triangular(7, 8.67, 10) Triangular(4, 6.5, 9) Triangular(7, 9.33, 10) Triangular(5, 7.5, 9) Triangular(5, 7.5, 9)
        Triangular(5, 7, 9) Triangular(5, 6.7, 9) Triangular(5, 7, 9) Triangular(5, 7, 9) Triangular(5, 7, 9)
        Triangular(7, 8, 9) Triangular(5, 6.5, 8) Triangular(7, 8, 9) Triangular(5, 7, 9) Triangular(5, 7, 9)
        Triangular(5, 6.5, 8) Triangular(2, 4.5, 6) Triangular(4, 6, 8) Triangular(4, 5, 6) Triangular(4, 5.5, 8)
    ]

    we = [
        [
            Triangular(0.8, 1, 1),
            Triangular(0.77, 0.93, 0.97),
            Triangular(0.73, 0.87, 0.93),
            Triangular(0.57, 0.7, 0.83),
            Triangular(0.7, 0.77, 0.9),
        ],
        [
            Triangular(0.8, 1, 1),
            Triangular(0.7, 0.93, 1),
            Triangular(0.7, 0.87, 1),
            Triangular(0.5, 0.7, 0.9),
            Triangular(0.7, 0.77, 0.9),
        ],
    ]

    decmat = fuzzydecmat([dm1, dm2])

    weights = prepare_weights(we)

    fns = [maximum for i = 1:5]
    result = fuzzytopsis(decmat, weights, fns)

    myorder = result.scores |> sortperm

    @test myorder[1] == 5
    @test myorder[2] == 3
    @test myorder[3] == 4
    @test myorder[4] == 2
    @test myorder[5] == 1



    @test isapprox(result.scores[1], 0.611, atol = atol)
    @test isapprox(result.scores[2], 0.540, atol = atol)
    @test isapprox(result.scores[3], 0.48, atol = atol)
    @test isapprox(result.scores[4], 0.505, atol = atol)
    @test isapprox(result.scores[5], 0.350, atol = atol)

end
