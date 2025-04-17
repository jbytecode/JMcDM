

@testset "Fuzzy Topsis -(Kore, N. B., Ravi, K., & Patil, S. B.(2017))" verbose = true begin

    """
    References:

    Kore, N. B., Ravi, K., & Patil, S. B.(2017). A simplified description of fuzzy TOPSIS 
    method for multi criteria decision making. International Research Journal of Engineering
    and Technology(IRJET), 4(5), 2047-2050.
    """

    @testset "Preparing decision matrix using multiple decision makers" begin
        # Two decision makers
        # Two alternatives 
        # Four criteria
        dm1 = [
            Triangular(3, 5, 7) Triangular(7, 9, 9) Triangular(1, 3, 5) Triangular(3, 5, 7)
            Triangular(5, 7, 9) Triangular(5, 7, 9) Triangular(1, 3, 5) Triangular(1, 3, 5)
        ]

        dm2 = [
            Triangular(3, 5, 7) Triangular(7, 9, 9) Triangular(3, 5, 7) Triangular(3, 5, 7)
            Triangular(5, 7, 9) Triangular(7, 9, 9) Triangular(1, 3, 5) Triangular(1, 3, 5)
        ]

        decmat = fuzzydecmat([dm1, dm2])

        expected = [
            Triangular(3, 5, 7) Triangular(7, 9, 9) Triangular(1, 4, 7) Triangular(3, 5, 7)
            Triangular(5, 7, 9) Triangular(5, 8, 9) Triangular(1, 3, 5) Triangular(1, 3, 5)
        ]

        n, p = decmat |> size

        for i = 1:n
            for j = 1:p
                @test decmat[i, j] == expected[i, j]
            end
        end
    end

    @testset "Preparing weight vector using multiple decision makers" begin
        # These are decision makers' weight vectors
        # There are 2 decision makers.
        weights = [
            [
                Triangular(5, 7, 9),
                Triangular(7, 9, 9),
                Triangular(7, 9, 9),
                Triangular(3, 5, 7),
            ],
            [
                Triangular(3, 5, 7),
                Triangular(5, 7, 9),
                Triangular(5, 7, 9),
                Triangular(1, 3, 5),
            ],
        ]

        summarizedweights = prepare_weights(weights)

        expected = [
            Triangular(3.000, 6.000, 9.000),
            Triangular(5.000, 8.000, 9.000),
            Triangular(5.000, 8.000, 9.000),
            Triangular(1.000, 4.000, 7.000),
        ]

        for i in eachindex(expected)
            @test expected[i] == summarizedweights[i]
        end
    end

    @testset "Triangular: Alternative: 2, Criteria: 4" begin

        eps = 0.01

        decmat = [
            Triangular(3, 5, 7) Triangular(7, 9, 9) Triangular(1, 4, 7) Triangular(3, 5, 7)
            Triangular(5, 7, 9) Triangular(5, 8, 9) Triangular(1, 3, 5) Triangular(1, 3, 5)
        ]

        n, p = size(decmat)

        w = [
            Triangular(3, 6, 9),
            Triangular(5, 8, 9),
            Triangular(5, 8, 9),
            Triangular(1, 4, 7),
        ]

        fns = [minimum, maximum, maximum, maximum]

        result = fuzzytopsis(decmat, w, fns)

        expected_normalized_mat = [
            Triangular(0.429, 0.600, 1.000) Triangular(0.778, 1.000, 1.000) Triangular(0.143, 0.571, 1.000) Triangular(0.429, 0.714, 1.000)
            Triangular(0.333, 0.429, 0.600) Triangular(0.556, 0.889, 1.000) Triangular(0.143, 0.429, 0.714) Triangular(0.143, 0.429, 0.714)
        ]

        for i = 1:n
            for j = 1:p
                @test isapprox(
                    result.normalized_decmat[i, j],
                    expected_normalized_mat[i, j],
                    atol = eps,
                )
            end
        end

        expected_weighted_norm = [
            Triangular(1.287, 3.600, 9.000) Triangular(3.890, 8.000, 9.000) Triangular(0.715, 4.568, 9.000) Triangular(0.429, 2.856, 7.000)
            Triangular(0.999, 2.574, 5.400) Triangular(2.780, 7.112, 9.000) Triangular(0.715, 3.432, 6.426) Triangular(0.143, 1.716, 4.998)
        ]

        for i = 1:n
            for j = 1:p
                @test isapprox(
                    result.weighted_normalized_decmat[i, j],
                    expected_weighted_norm[i, j],
                    atol = eps,
                )
            end
        end



        @test result.bestideal == [
            Triangular(9.0, 9.0, 9.0),
            Triangular(9.0, 9.0, 9.0),
            Triangular(9.0, 9.0, 9.0),
            Triangular(7.0, 7.0, 7.0),
        ]

        @test result.worstideal == [
            Triangular(1.0, 1.0, 1.0),
            Triangular(2.7777777777777777, 2.7777777777777777, 2.7777777777777777),
            Triangular(0.7142857142857142, 0.7142857142857142, 0.7142857142857142),
            Triangular(0.14285714285714285, 0.14285714285714285, 0.14285714285714285),
        ]

        @test result.sminus == [19.130795215674166, 13.675031586664522]

        @test result.splus == [18.352692130107226, 21.116560843933744]


        @test isapprox(result.scores[1], 0.51, atol = eps)
        @test isapprox(result.scores[2], 0.39, atol = eps)

    end


    @testset "Topsis with unknown direction" begin
		decmat = [
			Triangular(0.0850444, 0.281355, 0.30146)      Triangular(0.352535, 0.353548, 0.369791)    Triangular(0.481054, 0.860453, 0.975295);
			Triangular(0.138224, 0.175757, 0.251231)      Triangular(0.267265, 0.298295, 0.29918)     Triangular(0.310574, 0.775556, 0.900811);
			Triangular(0.0245844, 0.0540223, 0.232563)    Triangular(0.474525, 0.569292, 0.572759)    Triangular(0.682101, 0.811294, 0.926343);
			Triangular(0.200205, 0.260441, 0.33161)       Triangular(0.471592, 0.65859, 0.734439)     Triangular(0.890634, 0.899495, 0.968514)
		]

		weights = [
			Triangular(0.10, 0.20, 0.30),
			Triangular(0.20, 0.30, 0.40),
			Triangular(0.30, 0.40, 0.50),
		]

		fns = [maximum, minimum, sum]

		@test_throws UndefinedDirectionException fuzzytopsis(decmat, weights, fns)
	end
end
