@testset "MCDM functions" verbose = true begin

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

	@testset "MOOSRA" begin
		tol = 0.0001

		decmat = hcat(
			[25.0, 21, 19, 22],
			[65.0, 78, 53, 25],
			[7.0, 6, 5, 2],
			[20.0, 24, 33, 31],
		)
		weights = [0.25, 0.25, 0.25, 0.25]
		fns = [maximum, maximum, minimum, maximum]
		result = moosra(decmat, weights, fns)

		@test result isa MoosraResult

		@test isapprox(
			result.scores,
			[15.714285714285714, 20.499999999999996, 20.999999999999996, 39.0],
			atol = tol,
		)

		@test result.rankings == [1, 2, 3, 4]
		@test result.bestIndex == 4

		setting = MCDMSetting(decmat, weights, fns)
		result2 = mcdm(setting, MoosraMethod())
		@test result2.bestIndex == result.bestIndex
		@test result2.scores == result.scores
		@test result2 isa MoosraResult
	end

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

	@testset "ROV" begin
		tol = 0.01
		mat = [
			0.035 34.5 847 1.76 0.335 0.5 0.59 0.59
			0.027 36.8 834 1.68 0.335 0.665 0.665 0.665
			0.037 38.6 808 2.4 0.59 0.59 0.41 0.5
			0.028 32.6 821 1.59 0.5 0.59 0.59 0.41
		]


		w = [0.3306, 0.0718, 0.1808, 0.0718, 0.0459, 0.126, 0.126, 0.0472]

		fns = [minimum, minimum, minimum, minimum, maximum, minimum, minimum, maximum]

		result1::ROVResult = rov(mat, w, fns)


		@test result1 isa ROVResult
		@test isapprox(
			result1.uminus,
			[
				0.3349730210602759,
				0.4762288888888889,
				0.3640727272727273,
				0.6560048841354725,
			],
			atol = tol,
		)
		@test isapprox(
			result1.uplus,
			[0.03331764705882352, 0.0472, 0.06255882352941176, 0.029700000000000004],
			atol = tol,
		)

		@test isapprox(
			result1.scores,
			[
				0.1841453340595497,
				0.26171444444444447,
				0.21331577540106955,
				0.34285244206773624,
			],
			atol = tol,
		)

		@test result1.ranks == [4, 2, 3, 1]


		setting = MCDMSetting(mat, w, fns)
		result2 = mcdm(setting, ROVMethod())
		@test result2.ranks == result1.ranks
		@test result2.scores == result1.scores
		@test result2 isa ROVResult
	end

	@testset "SD" begin

		@testset "SD with example" begin
			tol = 0.01
			mat = [
				391152 251165 2063102 912 18784 0.009 0.049 0.196
				181681 118972 1310114 525 12087 0.009 0.042 0.157
				156478 105801 993245 708 12279 0.01 0.041 0.177
				57145 34707 339417 210 3733 0.013 0.055 0.268
				34947 17568 340159 77 2015 0.014 0.043 0.204
				32667 19308 201372 48 1091 0.008 0.029 0.217
				28945 18033 117762 48 886 0.007 0.021 0.178
				18893 13816 139431 35 943 0.01 0.035 0.213
				18191 9088 47664 43 731 0.01 0.021 0.186
				12852 4185 64770 3 376 0.011 0.075 0.285
				10878 7107 11200 1 78 0.003 0.033 0.198
				4958 1730 4656 7 274 0.017 0.053 0.215
				3901 2318 15598 17 357 0.023 0.001 0.155
				2742 1042 52632 1 106 0.022 0.1 0.384
				1734 771 1894 1 33 0.011 0.125 0.709
				1677 568 1941 1 39 0.011 0.129 0.633
			]

			fns = [maximum, maximum, maximum, minimum, minimum, minimum, maximum, maximum]

			result = sd(mat, fns)

			@test result isa SDResult
			@test isapprox(
				result.weights,
				[0.116, 0.117, 0.125, 0.137, 0.133, 0.116, 0.125, 0.131],
				atol = tol,
			)

			result1 = sd(mat, fns)
			@test result1 isa SDResult
			@test isapprox(
				result1.weights,
				[0.116, 0.117, 0.125, 0.137, 0.133, 0.116, 0.125, 0.131],
				atol = tol,
			)
		end


		@testset "SD without normalization" begin
			eps = 0.001
			decmat = hcat(
				[105000.0, 120000, 150000, 115000, 135000],
				[105.0, 110, 120, 105, 115],
				[10.0, 15, 12, 20, 15],
				[4.0, 4, 3, 4, 5],
				[300.0, 500, 550, 600, 400],
				[10.0, 8, 12, 9, 9],
			)
			functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

			sdresult = sd(decmat, functionlist, normalization = Normalizations.nullnormalization)
			w = sdresult.weights

			expected = [0.9925358892853197, 0.00036602915026898945, 0.0002123191795668205, 3.9701435571412785e-5, 0.006760910856275223, 8.515009299808652e-5]

			@test isapprox(w, expected, atol = eps)
		end
	end

	@testset "Grey Relational Analysis" begin

		tol = 0.0001

		decmat = hcat(
			[105000.0, 120000, 150000, 115000, 135000],
			[105.0, 110, 120, 105, 115],
			[10.0, 15, 12, 20, 15],
			[4.0, 4, 3, 4, 5],
			[300.0, 500, 550, 600, 400],
			[10.0, 8, 12, 9, 9],
		)
		functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

		w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

		result = grey(decmat, w, functionlist)

		@test isa(result, GreyResult)

		@test isapprox(
			result.scores,
			[
				0.525,
				0.7007142857142857,
				0.5464285714285715,
				0.5762820512820512,
				0.650952380952381,
			],
			atol = tol,
		)

		@test result.bestIndex == 2

		setting = MCDMSetting(decmat, w, functionlist)
		result2 = grey(setting)
		@test result2 isa GreyResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, GreyMethod())
		@test result3 isa GreyResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "TOPSIS" begin
		tol = 0.00001
		decmat = hcat(
			Float64[9, 8, 7],
			Float64[7, 7, 8],
			Float64[6, 9, 6],
			Float64[7, 6, 6])


		w = Float64[4, 2, 6, 8]

		fns = [maximum, maximum, maximum, maximum]

		result = topsis(decmat, w, fns)

		@test isa(result, TopsisResult)
		@test result.bestIndex == 2
		@test isapprox(result.scores, [0.3876870, 0.6503238, 0.0834767], atol = tol)

		setting = MCDMSetting(decmat, w, fns)
		result2 = topsis(setting)
		@test isa(result2, TopsisResult)
		@test result2.bestIndex == result.bestIndex
		@test result.scores == result2.scores

		result3 = mcdm(setting, TopsisMethod())
		@test isa(result3, TopsisResult)
		@test result3.bestIndex == result.bestIndex
		@test result3.scores == result.scores
	end

	@testset "VIKOR" begin
		tol = 0.01
		w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
		Amat = [
			100 92 10 2 80 70 95 80.0
			80 70 8 4 100 80 80 90
			90 85 5 0 75 95 70 70
			70 88 20 18 60 90 95 85
		]
		fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]

		result = vikor(Amat, w, fns)

		@test isa(result, VikorResult)
		@test result.bestIndex == 4

		@test isapprox(result.scores[1], 0.74, atol = tol)
		@test isapprox(result.scores[2], 0.73, atol = tol)
		@test isapprox(result.scores[3], 1.0, atol = tol)
		@test isapprox(result.scores[4], 0.0, atol = tol)

		setting = MCDMSetting(Amat, w, fns)
		result2 = vikor(setting)
		@test result.scores == result2.scores
		@test result.bestIndex == result2.bestIndex

		result3 = mcdm(setting, VikorMethod())
		@test result.scores == result3.scores
		@test result.bestIndex == result3.bestIndex
	end

	@testset "ELECTRE" begin
		tol = 0.00001
		w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
		Amat = [
			100 92 10 2 80 70 95 80.0
			80 70 8 4 100 80 80 90
			90 85 5 0 75 95 70 70
			70 88 20 18 60 90 95 85
		]
		fns = [maximum for i ∈ 1:8]
		result = electre(Amat, w, fns)

		@test isa(result, ElectreResult)
		@test isa(result.bestIndex, Tuple)
		@test result.bestIndex[1] == 4

		@test isapprox(
			result.C,
			[0.36936937, 0.01501502, -2.47347347, 2.08908909],
			atol = tol,
		)
		@test isapprox(result.D, [0.1914244, -0.1903929, 2.8843076, -2.8853391], atol = tol)

		setting = MCDMSetting(Amat, w, fns)
		result2 = electre(setting)
		@test result isa ElectreResult
		@test result.bestIndex == result2.bestIndex

		result3 = mcdm(setting, ElectreMethod())
		@test result3 isa ElectreResult
		@test result3.bestIndex == result.bestIndex
	end

	@testset "Electre (failed in previous release <= v0.2.5" begin
		decmat = hcat(
			[1.0, 2.0, 3.0, 2.0],
			[1.0, 2.0, 1.0, 1.0],
			[1.0, 3.0, 2.0, 2.0],
			[4.0, 2, 1, 4],
		)
		fns = [maximum, maximum, maximum, maximum]
		ws = [0.25, 0.25, 0.25, 0.25]
		e = electre(decmat, ws, fns)

		@test e isa ElectreResult
		@test e.bestIndex == (2, 1)
	end

	@testset "MOORA" begin
		@testset "MOORA Reference" begin
			tol = 0.00001
			w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
			Amat = [
				100 92 10 2 80 70 95 80.0
				80 70 8 4 100 80 80 90
				90 85 5 0 75 95 70 70
				70 88 20 18 60 90 95 85
			]
			fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]
			result = moora(Amat, w, fns)

			@test isa(result, MooraResult)
			@test isa(result.bestIndex, Int64)
			@test result.bestIndex == 4

			@test isapprox(
				result.scores,
				[0.33159387, 0.29014464, 0.37304311, 0.01926526],
				atol = tol,
			)

			setting = MCDMSetting(Amat, w, fns)
			result2 = moora(setting)
			@test result2 isa MooraResult
			@test result2.bestIndex == result.bestIndex
			@test result2.scores == result.scores

			result3 = mcdm(setting, MooraMethod())
			@test result3 isa MooraResult
			@test result3.bestIndex == result.bestIndex
			@test result3.scores == result.scores
		end

		@testset "MOORA Ratio" begin
			"""
			Reference for the example:
			KUNDAKCI, Nilsen. "Combined multi-criteria decision making approach based on MACBETH
			and MULTI-MOORA methods." Alphanumeric Journal 4.1 (2016): 17-26.
			"""
			tol = 0.001
			w = [0.20, 0.1684, 0.1579, 0.1474, 0.1158, 0.0842, 0.0737, 0.0421, 0.0105]
			fns = [
				minimum,
				minimum,
				maximum,
				maximum,
				maximum,
				maximum,
				maximum,
				maximum,
				minimum,
			]
			mat = [
				168000 4.2 35 5 5 5 5 136 109
				179697 4.1 34.5 5 4 4 5 190 107
				140600 4.5 33 3 3 3 3 150 119
				134950 4.3 28 3 2 4 4 190 112
				151980 5.6 35 3 4 4 3 170 147
				181632 4 35 5 3 4 5 190 106
				160620 4.8 33 2 3 3 2 180 125
				162900 4.5 35.4 3 4 3 2 143 119
				178000 4.2 32 2 3 2 3 180 110
			]

			result = moora(mat, w, fns, method = :ratio)

			@test result isa MooraResult
			@test isapprox(0.13489413914936565, result.scores[1], atol = tol)
			@test isapprox(0.11647832078367353, result.scores[2], atol = tol)
			@test isapprox(0.0627565796439602, result.scores[3], atol = tol)
			@test isapprox(0.06656348556629459, result.scores[4], atol = tol)
			@test isapprox(0.06687625630547807, result.scores[5], atol = tol)
			@test isapprox(0.10685768975933238, result.scores[6], atol = tol)
			@test isapprox(0.03301387703317765, result.scores[7], atol = tol)
			@test isapprox(0.06114965130074492, result.scores[8], atol = tol)
			@test isapprox(0.031152492476171283, result.scores[9], atol = tol)
		end
	end

	@testset "DEMATEL" begin
		tol = 0.00001
		K = [
			0 3 0 2 0 0 0 0 3 0
			3 0 0 0 0 0 0 0 0 2
			4 1 0 2 1 3 1 2 3 2
			4 1 4 0 1 2 0 1 0 0
			3 2 3 1 0 3 0 2 0 0
			4 1 4 4 0 0 0 1 1 3
			3 0 0 0 0 2 0 0 0 0
			3 0 4 3 2 3 1 0 0 0
			4 3 2 0 0 1 0 0 0 2
			2 1 0 0 0 0 0 0 3 0
		]


		result = dematel(K)

		@test isapprox(result.threshold, 0.062945, atol = tol)

		@test isapprox(
			result.c,
			[
				0.3991458,
				0.2261648,
				1.0204318,
				0.7538625,
				0.8096760,
				0.9780926,
				0.2717874,
				0.9455390,
				0.5960514,
				0.2937537,
			],
			atol = tol,
		)

		@test isapprox(
			result.r,
			[
				1.5527024,
				0.7251791,
				0.8551461,
				0.6895615,
				0.2059141,
				0.6790404,
				0.1057168,
				0.3163574,
				0.6484014,
				0.5164858,
			],
			atol = tol,
		)

		@test isapprox(
			result.influenceMatrix,
			[
				0.0 1.0 0.0 1.0 0.0 0.0 0.0 0.0 1.0 0.0
				1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0
				1.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0 1.0 1.0
				1.0 1.0 1.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0
				1.0 1.0 1.0 1.0 0.0 1.0 0.0 1.0 0.0 0.0
				1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0 1.0 1.0
				1.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0
				1.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0
				1.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0
				1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0
			],
			atol = tol,
		)

		@test isapprox(
			result.weights,
			[
				0.1686568559124561,
				0.07991375718719543,
				0.14006200243438863,
				0.10748052790517183,
				0.08789022388276985,
				0.12526272598854982,
				0.03067915023486491,
				0.10489168834828348,
				0.092654758940811,
				0.06250830916550884,
			],
			atol = tol,
		)

	end

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

	@testset "NDS" begin
		@testset "NDS - all maximum" begin
			cases = [
				1.0 2.0 3.0
				2.0 1.0 3.0
				1.0 3.0 2.0
				4.0 5.0 6.0
			]


			fns = [maximum, maximum, maximum]

			result = nds(cases, fns)

			@test isa(result, NDSResult)

			@test result.bestIndex == 4

			@test result.ranks == [0, 0, 0, 3]
		end

		@testset "NDS - all minimum" begin
			cases = [
				1.0 2.0 3.0 4.0
				2.0 4.0 6.0 8.0
				4.0 8.0 12.0 16.0
				8.0 16.0 24.0 32.0
			]

			nd = cases

			fns = [minimum, minimum, minimum, minimum]

			result = nds(nd, fns)

			@test isa(result, NDSResult)

			@test result.bestIndex == 1

			@test result.ranks == [3, 2, 1, 0]
		end
	end

	@testset "SAW" begin

		@testset "Example 1: 4 criteria × 4 alternatives" begin
			tol = 0.0001
			decmat = hcat(
				[25.0, 21, 19, 22],
				[65.0, 78, 53, 25],
				[7.0, 6, 5, 2],
				[20.0, 24, 33, 31],
			)
			weights = [0.25, 0.25, 0.25, 0.25]
			fns = [maximum, maximum, minimum, maximum]

			result = saw(decmat, weights, fns)

			@test result isa SawResult

			@test isapprox(
				result.scores,
				[0.681277, 0.725151, 0.709871, 0.784976],
				atol = tol,
			)

			result2 = saw(decmat, weights, fns)

			@test result2 isa SawResult

			@test isapprox(
				result2.scores,
				[0.681277, 0.725151, 0.709871, 0.784976],
				atol = tol,
			)

		end

		@testset "Example 2: 7 criteria × 5 alternatives " begin
			tol = 0.0001
			decmat = [
				4.0 7 3 2 2 2 2
				4.0 4 6 4 4 3 7
				7.0 6 4 2 5 5 3
				3.0 2 5 3 3 2 5
				4.0 2 2 5 5 3 6
			]

			weights = [0.283, 0.162, 0.162, 0.07, 0.085, 0.162, 0.076]
			fns = [maximum for i ∈ 1:7]
			result = saw(decmat, weights, fns)

			@test result isa SawResult
			@test isapprox(
				result.scores,
				[0.553228, 0.713485, 0.837428, 0.514657, 0.579342],
				atol = tol,
			)
			@test result.bestIndex == 3
			@test result.ranking == [3, 2, 5, 1, 4]

			setting = MCDMSetting(decmat, weights, fns)
			result2 = saw(setting)
			@test result2 isa SawResult
			@test result2.scores == result.scores
			@test result2.bestIndex == result.bestIndex

			result3 = mcdm(setting, SawMethod())
			@test result3 isa SawResult
			@test result3.scores == result.scores
			@test result3.bestIndex == result.bestIndex
		end
	end

	@testset "ARAS" begin

		tol = 0.0001

		mat = hcat(
			[105000.0, 120000, 150000, 115000, 135000],
			[105.0, 110, 120, 105, 115],
			[10.0, 15, 12, 20, 15],
			[4.0, 4, 3, 4, 5],
			[300.0, 500, 550, 600, 400],
			[10.0, 8, 12, 9, 9],
		)
		functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

		w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

		result = aras(mat, w, functionlist)
		@test isa(result, ARASResult)
		@test isapprox(
			result.scores,
			[0.81424068, 0.89288620, 0.76415790, 0.84225462, 0.86540635],
			atol = tol,
		)
		@test result.bestIndex == 2

		setting = MCDMSetting(mat, w, functionlist)
		result2 = aras(setting)
		@test result2 isa ARASResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, ArasMethod())
		@test result3 isa ARASResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "WPM" begin
		tol = 0.0001
		decmat = [
			3 12.5 2 120 14 3
			5 15 3 110 38 4
			3 13 2 120 19 3
			4 14 2 100 31 4
			3 15 1.5 125 40 4
		]

		weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

		fns = [maximum, minimum, minimum, maximum, minimum, maximum]

		result = wpm(decmat, weights, fns)
		@test result isa WPMResult
		@test isapprox(
			result.scores,
			[
				0.7975224331331,
				0.7532541470585,
				0.7647463553356,
				0.7873956894791,
				0.7674278741782,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = wpm(setting)
		@test result2 isa WPMResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, WPMMethod())
		@test result3 isa MCDMResult
		@test result3 isa WPMResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "WASPAS" begin
		tol = 0.0001
		decmat = [
			3 12.5 2 120 14 3
			5 15 3 110 38 4
			3 13 2 120 19 3
			4 14 2 100 31 4
			3 15 1.5 125 40 4
		]


		weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

		fns = [maximum, minimum, minimum, maximum, minimum, maximum]

		result = waspas(decmat, weights, fns)
		@test result isa WASPASResult
		@test isapprox(
			result.scores,
			[0.805021, 0.775060, 0.770181, 0.796424, 0.788239],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = waspas(setting)
		@test result2 isa WASPASResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, WaspasMethod())
		@test result3 isa WASPASResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "EDAS" begin
		tol = 0.0001
		decmat = [
			5000 5 5300 450.0
			4500 5 5000 400
			4500 4 4700 400
			4000 4 4200 400
			5000 4 7100 500
			5000 5 5400 450
			5500 5 6200 500
			5000 4 5800 450
		]

		weights = [0.25, 0.25, 0.25, 0.25]

		fns = [maximum, maximum, minimum, minimum]

		result = edas(decmat, weights, fns)
		@test result isa EDASResult
		@test isapprox(
			result.scores,
			[
				0.759594,
				0.886016,
				0.697472,
				0.739658,
				0.059083,
				0.731833,
				0.641691,
				0.385194,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = edas(setting)
		@test result2 isa EDASResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, EdasMethod())
		@test result3 isa EDASResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

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

	@testset "MABAC" begin

		tol = 0.0001
		decmat = [
			2 1 4 7 6 6 7 3000.0
			4 1 5 6 7 7 6 3500
			3 2 6 6 5 6 8 4000
			5 1 5 7 6 7 7 3000
			4 2 5 6 7 7 6 3000
			3 2 6 6 6 6 6 3500
		]


		weights = [0.293, 0.427, 0.067, 0.027, 0.053, 0.027, 0.053, 0.053]

		fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum]

		result = mabac(decmat, weights, fns)
		@test result isa MABACResult
		@test isapprox(
			result.scores,
			[-0.31132, -0.10898, 0.20035, 0.04218, 0.34452, 0.20035],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = mabac(setting)
		@test result2 isa MABACResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, MabacMethod())
		@test result3 isa MABACResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "MAIRCA" begin

		tol = 0.0001
		decmat = [
			6.952 8.000 6.649 7.268 8.000 7.652 6.316
			7.319 7.319 6.604 7.319 8.000 7.652 5.313
			7.000 7.319 7.652 6.952 7.652 6.952 4.642
			7.319 6.952 6.649 7.319 7.652 6.649 5.000
		]


		weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140]

		fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum]

		result = mairca(decmat, weights, fns)
		@test result isa MAIRCAResult
		@test isapprox(
			result.scores,
			[0.1206454, 0.0806646, 0.1458627, 0.1454237],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = mairca(setting)
		@test result2 isa MAIRCAResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, MaircaMethod())
		@test result3 isa MAIRCAResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "COPRAS" begin

		tol = 0.0001
		decmat = [
			2.50 240 57 45 1.10 0.333333
			2.50 285 60 75 4.00 0.428571
			4.50 320 100 65 7.50 1.111111
			4.50 365 100 90 7.50 1.111111
			5.00 400 100 90 11.00 1.111111
			2.50 225 60 45 1.10 0.333333
			2.50 270 57 60 4.00 0.428571
			4.50 330 100 70 7.50 1.111111
			4.50 365 100 80 7.50 1.111111
			5.00 380 110 65 8.00 1.111111
			2.50 285 65 80 4.00 0.400000
			4.00 280 75 65 4.00 0.400000
			4.50 365 102 95 7.50 1.111111
			4.50 400 102 95 7.50 1.111111
			6.00 450 110 95 11.00 1.176471
			6.00 510 110 105 11.00 1.176471
			6.00 330 140 110 18.50 1.395349
			2.50 240 65 80 4.00 0.400000
			4.00 280 75 75 4.00 0.400000
			4.50 355 102 95 7.50 1.111111
			4.50 385 102 90 7.50 1.111111
			5.00 385 114 95 7.50 1.000000
			6.00 400 110 90 11.00 1.000000
			6.00 480 110 95 15.00 1.000000
			6.00 440 140 100 18.50 1.200000
			6.00 500 140 100 18.50 1.200000
			5.00 450 125 100 15.00 1.714286
			6.00 500 150 125 18.50 1.714286
			6.00 515 180 140 22.00 2.307692
			7.00 550 200 150 30.00 2.307692
			6.00 500 180 140 15.00 2.307692
			6.00 500 180 140 18.50 2.307692
			6.00 500 180 140 22.00 2.307692
			7.00 500 180 140 30.00 2.307692
			7.00 500 200 140 37.00 2.307692
			7.00 500 200 140 45.00 2.307692
			7.00 500 200 140 55.00 2.307692
			7.00 500 200 140 75.00 2.307692
		]


		weights = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667]

		fns = [maximum, maximum, maximum, maximum, maximum, minimum]

		result = copras(decmat, weights, fns)
		@test result isa COPRASResult
		@test isapprox(
			result.scores,
			[
				0.44194,
				0.44395,
				0.41042,
				0.44403,
				0.48177,
				0.44074,
				0.42430,
				0.41737,
				0.43474,
				0.44382,
				0.46625,
				0.48602,
				0.45019,
				0.45825,
				0.51953,
				0.54265,
				0.56134,
				0.45588,
				0.49532,
				0.44788,
				0.45014,
				0.48126,
				0.51586,
				0.56243,
				0.58709,
				0.60091,
				0.51850,
				0.61085,
				0.65888,
				0.75650,
				0.61430,
				0.63486,
				0.65542,
				0.72065,
				0.77680,
				0.82379,
				0.88253,
				1.00000,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = copras(setting)
		@test result2 isa COPRASResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, CoprasMethod())
		@test result3 isa COPRASResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "PROMETHEE group" begin

		@testset "U-Shape" begin
			@test prometUShape(0.0, 1.0, 1.0) == 0.0
			@test prometUShape(1.0, 1.0, 1.0) == 1.0
		end

		@testset "Quasi" begin
			@test prometQuasi(0.0, 0.5, 1.0) == 0.0
			@test prometQuasi(0.6, 0.5, 1.0) == 1.0
		end

		@testset "Level" begin
			@test prometLevel(0, 0.5, 1.0) == 0.0
			@test prometLevel(0.6, 0.5, 0.9) == 0.5
			@test prometLevel(1.0, 0.5, 0.9) == 1.0
		end

		@testset "PROMETHEE" begin
			tol = 0.005
			decmat = [
				42.0 35 43 51
				89 72 92 85
				14 85 17 40
				57 60 45 80
				48 32 43 40
				71 45 60 85
				69 40 72 55
				64 35 70 60
			]
			qs = [49, nothing, 45, 30]
			ps = [100, 98, 95, 80]
			weights = [0.25, 0.35, 0.22, 0.18]
			fns = [maximum, maximum, maximum, maximum]
			prefs = convert(
				Array{Function, 1},
				[prometLinear, prometVShape, prometLinear, prometLinear],
			)

			result = promethee(decmat, weights, fns, prefs, qs, ps)

			@test result isa PrometheeResult
			@test isapprox(
				result.scores,
				[0.07, -0.15, -0.06, -0.05, 0.10, 0.0, 0.03, 0.06],
				atol = tol,
			)
			@test result.bestIndex == 5

			setting = MCDMSetting(decmat, weights, fns)
			result2 = promethee(setting, prefs, qs, ps)
			@test result2 isa PrometheeResult
			@test result2.scores == result.scores
			@test result2.bestIndex == result.bestIndex

			result3 = mcdm(setting, PrometheeMethod(prefs, qs, ps))
			@test result3 isa PrometheeResult
			@test result3.scores == result.scores
			@test result3.bestIndex == result.bestIndex
		end
	end

	@testset "CoCoSo" begin
		tol = 0.0001
		decmat = [
			60.00 0.40 2540.00 500.00 990.00
			6.35 0.15 1016.00 3000.00 1041.00
			6.80 0.10 1727.20 1500.00 1676.00
			10.00 0.20 1000.00 2000.00 965.00
			2.50 0.10 560.00 500.00 915.00
			4.50 0.08 1016.00 350.00 508.00
			3.00 0.10 1778.00 1000.00 920.00
		]


		weights = [0.036, 0.192, 0.326, 0.326, 0.120]

		lambda = 0.5

		fns = [maximum, minimum, maximum, maximum, maximum]

		result = cocoso(decmat, weights, fns, lambda = lambda)
		@test result isa CoCoSoResult
		@test isapprox(
			result.scores,
			[
				2.0413128390265998,
				2.787989783418825,
				2.8823497955972495,
				2.4160457689259287,
				1.2986918936013303,
				1.4431429073391682,
				2.519094173200623,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, weights, fns)
		result2 = cocoso(setting)
		@test result2 isa CoCoSoResult
		@test result2.scores == result.scores
		@test result2.bestIndex == result.bestIndex

		result3 = mcdm(setting, CocosoMethod())
		@test result3 isa CoCoSoResult
		@test result3.scores == result.scores
		@test result3.bestIndex == result.bestIndex
	end

	@testset "CRITIC" begin
		tol = 0.0001
		decmat = [
			12.9918 0.7264 -1.1009 1.598139592
			4.1201 5.8824 3.4483 1.021563567
			4.1039 0.0000 -0.5076 0.984469444
		]

		fns = [maximum, maximum, minimum, maximum]

		result = critic(decmat, fns)
		@test result isa CRITICResult
		@test isapprox(
			result.w,
			[0.16883925, 0.418444976, 0.249124763, 0.163591012],
			atol = tol,
		)
		@test isapprox(result.scores, [1.0380664664796384, 2.572718248762683, 1.5316754449023655, 1.005800182228836], atol = tol)
		@test isapprox(
			result.correlationmatrix,
			[
				0.0 1.3972590509606788 0.4009928509605405 0.0013698033055495884;
				1.3972590509606788 0.0 1.9728086997410341 1.348697428776955;
				0.4009928509605405 1.9728086997410341 0.0 0.44371094387732823;
				0.0013698033055495884 1.348697428776955 0.44371094387732823 0.0
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, zeros(4), fns)
		result2 = critic(setting)
		@test result2 isa CRITICResult
		@test result2.w == result.w
	end

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

	@testset "CODAS" begin
		tol = 0.0001
		decmat = [
			60.000 0.400 2540 500 990
			6.350 0.150 1016 3000 1041
			6.800 0.100 1727.2 1500 1676
			10.000 0.200 1000 2000 965
			2.500 0.100 560 500 915
			4.500 0.080 1016 350 508
			3.000 0.100 1778 1000 920
		]


		w = [0.036, 0.192, 0.326, 0.326, 0.12]
		fns = [maximum, minimum, maximum, maximum, maximum]

		result = codas(decmat, w, fns)
		@test result isa CODASResult
		@test isapprox(
			result.scores,
			[
				0.512176491,
				1.463300035,
				1.07153259,
				-0.212467998,
				-1.851520552,
				-1.17167677,
				0.188656204,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, w, fns)
		result2 = codas(setting)
		@test result2 isa CODASResult
		@test result2.scores == result.scores

		result3 = mcdm(setting, CodasMethod())
		@test result3 isa CODASResult
		@test result3.scores == result.scores
	end

	@testset "MEREC" begin
		tol = 0.0001
		decmat = hcat(
			[450.0, 10, 100, 220, 5],
			[8000, 9100, 8200, 9300, 8400],
			[54, 2, 31, 1, 23],
			[145, 160, 153, 162, 158],
		)

		fns = [maximum, maximum, minimum, minimum]

		result = merec(decmat, fns)
		@test result isa MERECResult
		@test isapprox(
			result.w,
			[
				0.5752216672093823,
				0.01409659116846726,
				0.40156136388773117,
				0.009120377734419302,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, zeros(4), fns)
		result2 = merec(setting)
		@test result2 isa MERECResult
		@test result2.w == result.w
	end

	@testset "PIV" begin
		tol = 0.0001

		decmat = [
			60 2.5 2540 500 990
			6.35 6.667 1016 3000 1041
			6.8 10 1727 1500 1676
			10 5 1000 2000 965
			2.5 9.8 560 500 915
			4.5 12.5 1016 350 508
			3 10 1778 1000 920
		]

		w = [0.1761, 0.2042, 0.2668, 0.1243, 0.2286]

		fns = [maximum, maximum, maximum, maximum, maximum]
		fns2 = [minimum for i ∈ 1:5]

		result = piv(decmat, w, fns)
		result2 = piv(decmat, w, fns2)

		@test result2 isa PIVResult

		@test result isa PIVResult
		@test isapprox(
			result.scores,
			[
				0.22086675609968962,
				0.35854940101222144,
				0.2734184099704686,
				0.4005382183676046,
				0.4581157878699193,
				0.43595371718873477,
				0.3580651803072459,
			],
			atol = tol,
		)
		@test result.bestIndex == 1
		@test result.ranking == [1, 3, 7, 2, 4, 6, 5]
	end

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

	@testset "LOPCOW" begin
		tol = 0.0001
		decmat = [
			21.8 14.1 10.7 1.6 1.8 770.0 12750.0 18.0 5100.0 1.5 9.1 1.054 4.196 29.407 7.03 15.08 9.705;
			16.4 8.5 13.9 1.2 1.3 524.0 12087.0 5.7 2941.0 2.208 15.2 1.123 3.86 5.228 14.724 32.103 19.0;
			14.5 7.0 2.3 0.2 0.2 238.0 3265.0 1.9 320.0 2.32 16.202 1.008 3.095 5.549 17.34 65.129 32.056;
			18.2 10.3 11.4 1.2 1.1 835.0 16037.0 21.3 4332.0 0.875 9.484 0.856 2.191 23.75 13.1 58.157 27.46;
			18.5 8.1 11.1 1.0 1.1 504.0 9464.0 1.4 1743.0 2.95 0.7 0.479 2.44 8.77 13.48 33.45 17.68;
			18.7 11.4 10.8 1.3 1.5 1227.0 24053.0 20.0 6521.0 0.733 1.6 0.857 2.377 4.985 11.743 26.732 24.485;
			18.5 12.6 10.8 1.4 1.8 912.0 18800.0 18.2 5300.0 1.29 8.27 0.558 0.635 5.22 13.829 31.914 7.515;
			16.4 6.7 12.6 0.9 0.9 951.0 16767.0 22.0 3917.0 2.46 3.9 0.724 0.568 4.491 14.357 28.869 7.313;
			15.2 6.3 6.9 0.5 0.5 1013.0 20170.0 10.97 4060.0 1.67 1.7 0.704 2.96 3.24 10.029 60.981 23.541
		]

		fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum, minimum, minimum, minimum, minimum, minimum, minimum]

		result = lopcow(decmat, fns)
		@test result isa LOPCOWResult
		@test isapprox(
			result.w,
			[
				0.0494739618585499,
				0.0366230783749353,
				0.0845662443200203,
				0.0705594164719862,
				0.0637406420860843,
				0.0660734602415126,
				0.0699299682542297,
				0.0504004077191502,
				0.0689844249442893,
				0.0491618867560788,
				0.0555597725236513,
				0.0487457716462668,
				0.0482437589634006,
				0.0762536089544412,
				0.0550717149127653,
				0.0532072757707825,
				0.0534046062018556,
			],
			atol = tol,
		)

		setting = MCDMSetting(decmat, zeros(17), fns)
		result2 = lopcow(setting)
		@test result2 isa LOPCOWResult
		@test result2.w == result.w
	end

	@testset "OCRA" begin
		tol = 0.0001
		decisionMat = [
			8.0 16.0 1.5 1.2 4200.0 5.0 5.0 314.0 185.0;
			8.0 16.0 1.0 1.3 4200.0 5.0 4.0 360.0 156.0;
			10.1 16.0 2.0 1.3 4060.0 5.0 3.0 503.0 160.0;
			10.1 8.0 1.0 1.5 5070.0 2.0 4.0 525.0 200.0;
			10.0 16.0 2.0 1.2 6350.0 5.0 3.0 560.0 190.0;
			10.1 16.0 1.0 1.2 5500.0 2.0 2.0 521.0 159.0;
			10.1 64.0 2.0 1.7 5240.0 5.0 3.0 770.0 199.0;
			7.0 32.0 1.0 1.8 3000.0 3.0 4.0 364.0 157.0;
			10.1 16.0 1.0 1.3 3540.0 5.0 3.0 510.0 171.0;
			9.7 16.0 2.0 1.83 7500.0 6.0 2.0 550.0 170.0
		]
		fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum, minimum]
		weights = [0.167, 0.039, 0.247, 0.247, 0.116, 0.02, 0.056, 0.027, 0.081]

		result = ocra(decisionMat, weights, fns)
		@test result isa OCRAResult
		@test isapprox(
			result.scores,
			[
				0.1439209390821490,
				0.0241065507104361,
				0.2734201159562310,
				0.0429791654417769,
				0.3185195380415760,
				0.0024882426914911,
				0.5921715172301160,
				0.1139028947061430,
				0.0000000000000000,
				0.4787485498471800,
			],
			atol = tol,
		)

		setting = MCDMSetting(decisionMat, weights, fns)
		result2 = ocra(setting)
		@test result2 isa OCRAResult
		@test result2.scores == result.scores
	end

	@testset "LMAW" begin
		tol = 0.0001
		decisionMat = [
			647.34 6.24 49.87 19.46 212.58 6.75;
			115.64 3.24 16.26 9.69 207.59 3.00;
			373.61 5.00 26.43 12.00 184.62 3.74;
			37.63 2.48 2.85 9.25 142.50 3.24;
			858.01 4.74 62.85 45.96 267.95 4.00;
			222.92 3.00 19.24 21.46 221.38 3.49
		]
		weights = [0.215, 0.126, 0.152, 0.091, 0.19, 0.226]
		fns = [maximum, maximum, minimum, minimum, minimum, maximum]

		result = lmaw(decisionMat, weights, fns)
		@test result isa LMAWResult
		@test isapprox(
			result.scores,
			[
				4.839005264308832,
				4.679718180594332,
				4.797731427991642,
				4.732145373983716,
				4.73416833375772,
				4.702247270959649,
			],
			atol = tol,
		)

		setting = MCDMSetting(decisionMat, weights, fns)
		result2 = lmaw(setting)
		@test result2 isa LMAWResult
		@test result2.scores == result.scores
	end

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
end
