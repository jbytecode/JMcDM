@testset "AHP" verbose = true begin 
    @testset "AHP - RI" begin
		@test iszero(ahp_RI(1))
		@test iszero(ahp_RI(2))
		@test ahp_RI(16) == 1.59
	end

	@testset "AHP - Consistency" begin

		tol = 0.00001

		K = [
			1 7 (1/5) (1/8) (1/2) (1/3) (1/5) 1
			(1/7) 1 (1/8) (1/9) (1/4) (1/5) (1/9) (1/8)
			5 8 1 (1/3) 4 2 1 1
			8 9 3 1 7 5 3 3
			2 4 (1/4) (1/7) 1 (1/2) (1/5) (1/5)
			3 5 (1/2) (1/5) 2 1 (1/3) (1/3)
			5 9 1 (1/3) 5 3 1 1
			1 8 1 (1/3) 5 3 1 1
		]

		dmat = K
		result::AHPConsistencyResult = ahp_consistency(dmat)

		@test isa(result, AHPConsistencyResult)

		@test result.isConsistent

		@test isapprox(result.CR, 0.07359957154133831, atol = tol)

		@test isapprox(result.CI, 0.10377539587328702, atol = tol)

		@test isapprox(result.lambda_max, 8.72642777111301, atol = tol)

		@test isapprox(
			result.pc,
			[
				8.40982182534543
				8.227923797501001
				8.95201017080425
				8.848075127995905
				8.860427038870013
				8.941497805932498
				8.946071053879708
				8.62559534857526
			],
			atol = tol,
		)
	end

	@testset "AHP" begin

		tol = 0.00001

		K = [
			1 7 1/5 1/8 1/2 1/3 1/5 1
			1/7 1 1/8 1/9 1/4 1/5 1/9 1/8
			5 8 1 1/3 4 2 1 1
			8 9 3 1 7 5 3 3
			2 4 1/4 1/7 1 1/2 1/5 1/5
			3 5 1/2 1/5 2 1 1/3 1/3
			5 9 1 1/3 5 3 1 1
			1 8 1 1/3 5 3 1 1
		]

		A1 = [
			1 3 1/5 2
			1/3 1 1/7 1/3
			5 7 1 4
			1/2 3 1/4 1
		]
		A2 = [
			1 1/2 4 5
			2 1 6 7
			1/4 1/6 1 3
			1/5 1/7 1/3 1
		]
		A3 = [
			1 1/2 1/6 3
			2 1 1/4 5
			6 4 1 9
			1/3 1/5 1/9 1
		]
		A4 = [
			1 7 1/4 2
			1/7 1 1/9 1/5
			4 9 1 5
			1/2 5 1/5 1
		]
		A5 = [
			1 6 2 3
			1/6 1 1/4 1/3
			1/2 4 1 2
			1/3 3 1/2 1
		]
		A6 = [
			1 1/4 1/2 1/7
			4 1 2 1/3
			2 1/2 1 1/5
			7 3 5 1
		]
		A7 = [
			1 3 7 1
			1/3 1 4 1/3
			1/7 1/4 1 1/7
			1 3 7 1
		]
		A8 = [
			1 2 5 8
			1/2 1 3 6
			1/5 1/3 1 3
			1/8 1/6 1/3 1
		]

		km = K
		as = [A1, A2, A3, A4, A5, A6, A7, A8]

		result = ahp(as, km)

		@test isa(result, AHPResult)

		@test result.bestIndex == 3

		@test isapprox(
			result.scores,
			[0.2801050, 0.1482273, 0.3813036, 0.1903641],
			atol = tol,
		)
	end
end 