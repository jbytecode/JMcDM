@testset "Fuzzy SAW" verbose = true begin

	@testset "SAW example" verbose = true begin

		atol = 0.01

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

		fns = [maximum, minimum, maximum]

		result = fuzzysaw(decmat, weights, fns)

		expected_scores = [0.7493752134952851, 0.6928754504446207, 0.5061604460964446, 0.6477328374432223]

		@test isapprox(expected_scores, result.scores, atol = atol)
	end

	@testset "SAW with unknown direction" begin
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

		@test_throws UndefinedDirectionException fuzzysaw(decmat, weights, fns)
	end

end
