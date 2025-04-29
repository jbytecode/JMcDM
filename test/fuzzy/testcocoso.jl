#@testset "Fuzzy Cocoso" verbose = true begin
#    @testset "Pamukkale - Master Thesis Example" verbose = true begin
#
#        """
#        Reference: 
#        Yenilmezel Alıcı, S. (2023). Bulanık çok kriterli karar verme yöntemleri ile bir işletme 
#        için insan kaynakları yönetimi uygulaması seçimi (Master's thesis). Pamukkale Üniversitesi
#        """
#
#        atol = 0.001
#
#        decmat = [
#            Triangular(0.6253, 0.9168, 1.0000) Triangular(0.3625, 0.4465, 0.5835) Triangular(0.5835, 0.8335, 1.0000) Triangular(0.6253, 0.9168, 1.0000) Triangular(0.4500, 0.5835, 0.8335) Triangular(0.4750, 0.6253, 0.9168) Triangular(0.6670, 1.0000, 1.0000)
#            Triangular(0.4750, 0.6253, 0.9168) Triangular(0.3625, 0.4465, 0.5835) Triangular(0.4083, 0.5168, 0.7085) Triangular(0.4750, 0.6253, 0.9168) Triangular(0.3095, 0.3665, 0.4500) Triangular(0.6253, 0.9168, 1.0000) Triangular(0.2520, 0.2888, 0.3380)
#            Triangular(0.2290, 0.2590, 0.2978) Triangular(0.3625, 0.4465, 0.5835) Triangular(0.2500, 0.2860, 0.3330) Triangular(0.6253, 0.9168, 1.0000) Triangular(0.3665, 0.4500, 0.5835) Triangular(0.4750, 0.6253, 0.9168) Triangular(0.2888, 0.3380, 0.4083)
#            Triangular(0.3095, 0.3665, 0.4500) Triangular(0.3625, 0.4465, 0.5835) Triangular(0.3213, 0.3833, 0.4750) Triangular(0.3833, 0.4750, 0.6253) Triangular(0.4500, 0.5835, 0.8335) Triangular(0.3833, 0.4750, 0.6253) Triangular(0.3748, 0.4250, 0.5418)
#        ]
#
#        w = [
#            Triangular(0.0550, 0.1505, 0.4828),
#            Triangular(0.0287, 0.0369, 0.0892),
#            Triangular(0.0528, 0.0879, 0.2227),
#            Triangular(0.0789, 0.1497, 0.2409),
#            Triangular(0.0868, 0.1701, 0.2761),
#            Triangular(0.0838, 0.1580, 0.2573),
#            Triangular(0.1251, 0.2468, 0.4056),
#        ]
#
#        fns = [minimum, maximum, minimum, maximum, maximum, maximum, maximum]
#
#        expectedS = [
#            Triangular(0.1361, 0.5770, 1.5927),
#            Triangular(0.0711, 0.3699, 1.1800),
#            Triangular(0.1561, 0.5078, 1.4873),
#            Triangular(0.1200, 0.4018, 1.3518),
#        ]
#
#        expectedP = [
#            Triangular(3.6023, 6.2931, 6.5465),
#            Triangular(3.6211, 5.8318, 5.8561),
#            Triangular(5.2808, 6.1815, 6.3293),
#            Triangular(3.6526, 6.0029, 6.1911),
#        ]
#
#        # Possibly incorrect scores
#        # expectedScores = [
#        # 	2.7571,
#        # 	2.1085,
#        # 	2.7728,
#        # 	2.3190,
#        # ]
#
#
#        expectedka = [
#            Triangular(0.1224, 0.2626, 0.4891),
#            Triangular(0.1209, 0.2370, 0.4228),
#            Triangular(0.1781, 0.2557, 0.4698),
#            Triangular(0.1236, 0.2448, 0.4533),
#        ]
#
#        expectedkb = [
#            Triangular(2.9150, 9.8658, 24.2267),
#            Triangular(2.0052, 6.8231, 18.2286),
#            Triangular(3.6619, 8.8614, 22.6837),
#            Triangular(2.7025, 7.3190, 20.7395),
#        ]
#
#        expectedkc = [
#            Triangular(0.4593, 0.8441, 1.0000),
#            Triangular(0.4536, 0.7620, 0.8645),
#            Triangular(0.6680, 0.8219, 0.9604),
#            Triangular(0.4635, 0.7869, 0.9268),
#        ]
#
#        expectedfa = [0.2914, 0.2603, 0.3012, 0.2739]
#
#        expectedfb = [12.3358, 9.0190, 11.7356, 10.2537]
#
#        expectedfc = [0.7678, 0.6934, 0.8168, 0.7257]
#
#        expectedScores = [5.8677, 4.5005, 5.7084, 5.0189]
#
#
#        n, p = size(decmat)
#
#        result = fuzzycocoso(decmat, w, fns)
#
#
#        @testset "Normalized Decision Matrix" begin
#            @test isapprox(
#                result.normalized_decmat[1, 1],
#                Triangular(0.0000, 0.1080, 0.4861),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 2],
#                Triangular(0.0000, 0.3801, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 3],
#                Triangular(0.0000, 0.2220, 0.5553),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 4],
#                Triangular(0.3924, 0.8650, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 5],
#                Triangular(0.2681, 0.5229, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 6],
#                Triangular(0.1488, 0.3924, 0.8650),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[1, 7],
#                Triangular(0.5548, 1.0000, 1.0000),
#                atol=atol,
#            )
#
#            @test isapprox(
#                result.normalized_decmat[2, 1],
#                Triangular(0.1080, 0.4861, 0.6809),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 2],
#                Triangular(0.0000, 0.3801, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 3],
#                Triangular(0.3887, 0.6443, 0.7890),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 4],
#                Triangular(0.1488, 0.3924, 0.8650),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 5],
#                Triangular(0.0000, 0.1088, 0.2681),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 6],
#                Triangular(0.3924, 0.8650, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[2, 7],
#                Triangular(0.0000, 0.0491, 0.1150),
#                atol=atol,
#            )
#
#            @test isapprox(
#                result.normalized_decmat[3, 1],
#                Triangular(0.9108, 0.9611, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 2],
#                Triangular(0.0000, 0.3801, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 3],
#                Triangular(0.8893, 0.9520, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 4],
#                Triangular(0.3924, 0.8650, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 5],
#                Triangular(0.1088, 0.2681, 0.5229),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 6],
#                Triangular(0.1488, 0.3924, 0.8650),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[3, 7],
#                Triangular(0.0491, 0.1150, 0.2089),
#                atol=atol,
#            )
#
#            @test isapprox(
#                result.normalized_decmat[4, 1],
#                Triangular(0.7134, 0.8217, 0.8956),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 2],
#                Triangular(0.0000, 0.3801, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 3],
#                Triangular(0.7000, 0.8223, 0.9050),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 4],
#                Triangular(0.0000, 0.1488, 0.3924),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 5],
#                Triangular(0.2681, 0.5229, 1.0000),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 6],
#                Triangular(0.0000, 0.1488, 0.3924),
#                atol=atol,
#            )
#            @test isapprox(
#                result.normalized_decmat[4, 7],
#                Triangular(0.1641, 0.2313, 0.3874),
#                atol=atol,
#            )
#      end
#
#        @testset "Weighted Normalized Decision Matrix" begin
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 1],
#                Triangular(0.0000, 0.0163, 0.2347),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 2],
#                Triangular(0.0000, 0.0140, 0.0892),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 3],
#                Triangular(0.0000, 0.0195, 0.1237),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 4],
#                Triangular(0.0310, 0.1295, 0.2409),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 5],
#                Triangular(0.0233, 0.0889, 0.2761),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 6],
#                Triangular(0.0125, 0.0620, 0.2226),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[1, 7],
#                Triangular(0.0694, 0.2468, 0.4056),
#                atol=atol,
#            )
#
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 1],
#                Triangular(0.0059, 0.0732, 0.3288),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 2],
#                Triangular(0.0000, 0.0140, 0.0892),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 3],
#                Triangular(0.0205, 0.0566, 0.1757),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 4],
#                Triangular(0.0117, 0.0587, 0.2084),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 5],
#                Triangular(0.0000, 0.0185, 0.0740),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 6],
#                Triangular(0.0329, 0.1367, 0.2573),
#                atol=atol,
#            )
#            @test isapprox(
#                result.weighted_normalized_decmat[2, 7],
#                Triangular(0.0000, 0.0121, 0.0466),
#                atol=atol,
#            )
#        end
#
#        @testset "S values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedS[i], result.S[i], atol=atol)
#            end
#        end
#
#
#        @testset "P values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedP[i], result.P[i], atol=atol)
#            end
#        end
#
#        @testset "Expected kA values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedka[i], result.kA[i], atol=atol)
#            end
#        end
#
#        @testset "Expected kC values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedkb[i], result.kB[i], atol=atol)
#            end
#        end
#
#        @testset "Expected kC values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedkc[i], result.kC[i], atol=atol)
#            end
#        end
#
#        @testset "Expected fa values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedfa[i], result.fa[i], atol=atol)
#            end
#        end
#
#        @testset "Expected fb values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedfb[i], result.fb[i], atol=atol)
#            end
#        end
#
#        @testset "Expected fc values" begin
#            for i ∈ 1:4
#                @test isapprox(expectedfc[i], result.fc[i], atol=atol)
#            end
#        end
#
#        @testset "Scores" begin
#            for i ∈ 1:4
#                @test isapprox(expectedScores[i], result.scores[i], atol=atol)
#            end
#        end
#end
#
#
#
    @testset "Cocoso with unknown direction" begin
        decmat = [
            Triangular(0.0850444, 0.281355, 0.30146) Triangular(0.352535, 0.353548, 0.369791) Triangular(0.481054, 0.860453, 0.975295);
            Triangular(0.138224, 0.175757, 0.251231) Triangular(0.267265, 0.298295, 0.29918) Triangular(0.310574, 0.775556, 0.900811);
            Triangular(0.0245844, 0.0540223, 0.232563) Triangular(0.474525, 0.569292, 0.572759) Triangular(0.682101, 0.811294, 0.926343);
            Triangular(0.200205, 0.260441, 0.33161) Triangular(0.471592, 0.65859, 0.734439) Triangular(0.890634, 0.899495, 0.968514)
        ]

        weights = [
            Triangular(0.10, 0.20, 0.30),
            Triangular(0.20, 0.30, 0.40),
            Triangular(0.30, 0.40, 0.50),
        ]

        fns = [maximum, minimum, sum]

        @test_throws UndefinedDirectionException fuzzycocoso(decmat, weights, fns)
    end


    @testset "Cocoso with a <= b <= c error fixed" begin
        #A NEW HYBRID FUZZY PSI-PIPRECIA-COCOSO MCDM BASED APPROACH TO SOLVING THE TRANSPORTATION COMPANY SELECTION PROBLEM

        decmat = [
            Triangular(0.193, 0.408, 0.612) Triangular(0.572, 0.774, 0.939) Triangular(0.500, 0.700, 0.900) Triangular(0.500, 0.700, 0.900) Triangular(0.193, 0.408, 0.612) Triangular(0.332, 0.535, 0.736) Triangular(0.368, 0.572, 0.774);
            Triangular(0.300, 0.500, 0.700) Triangular(0.572, 0.774, 0.939) Triangular(0.408, 0.612, 0.814) Triangular(0.100, 0.300, 0.500) Triangular(0.368, 0.572, 0.774) Triangular(0.500, 0.700, 0.900) Triangular(0.612, 0.814, 0.959);
            Triangular(0.408, 0.612, 0.814) Triangular(0.572, 0.774, 0.939) Triangular(0.612, 0.814, 0.959) Triangular(0.856, 0.979, 1.000) Triangular(0.612, 0.814, 0.959) Triangular(0.856, 0.979, 1.000) Triangular(0.814, 0.959, 1.000);
            Triangular(0.125, 0.332, 0.535) Triangular(0.241, 0.451, 0.654) Triangular(0.612, 0.814, 0.959) Triangular(0.100, 0.300, 0.500) Triangular(0.368, 0.572, 0.774) Triangular(0.572, 0.774, 0.939) Triangular(0.612, 0.814, 0.959);
            Triangular(0.125, 0.332, 0.535) Triangular(0.241, 0.451, 0.654) Triangular(0.572, 0.774, 0.939) Triangular(0.535, 0.736, 0.919) Triangular(0.408, 0.612, 0.814) Triangular(0.814, 0.959, 1.000) Triangular(0.612, 0.814, 0.959)
        ]

        w = [
            Triangular(0.056, 0.259, 0.852),
            Triangular(0.026, 0.073, 0.252),
            Triangular(0.038, 0.114, 0.393),
            Triangular(0.021, 0.070, 0.283),
            Triangular(0.047, 0.180, 0.634),
            Triangular(0.039, 0.138, 0.537),
            Triangular(0.051, 0.167, 0.638)
        ]

        fns = [minimum, maximum, maximum, maximum, minimum, maximum, maximum]

        result = fuzzycocoso(decmat, w, fns)

        expectedP = Triangular[Triangular(3.0752659727905374, 6.373449352868858, 6.945695497063656), Triangular(2.472177709371581, 6.338145127897136, 6.933466450775307), Triangular(4.1355456400409905, 6.397974239058166, 6.934283326419113), Triangular(2.6678714068492844, 6.46592729971361, 6.950304488789887), Triangular(3.630264242198866, 6.5599935136565, 6.9642863923685745)]

        expectedS = Triangular[Triangular(0.06571679362617011, 0.5407622959798692, 2.9910136886050607), Triangular(0.062444546802169196, 0.5163560039065845, 2.8453343404949063), Triangular(0.11062179911159559, 0.6079443791868301, 2.8922530022320156), Triangular(0.08179833244299206, 0.6028081249873337, 3.093613787277172), Triangular(0.10086414617431216, 0.6572624590969423, 3.22703141226397)]

        expectedScores = [9.04527020178248, 8.634485417049557, 9.176126641267752, 9.372807521302947, 9.891697055452338]

        
		scores = result.scores 

		ranking = sortperm(scores |> reverse)

		@test ranking == [4, 5, 3, 2, 1]

        for i in eachindex(result.P)
            @test isapprox(expectedP[i], result.P[i], atol=0.001)    
        end
        
        for i in eachindex(result.S)
            @test isapprox(expectedS[i], result.S[i], atol=0.001)    
        end

        for i in eachindex(result.scores)
            @test isapprox(expectedScores[i], result.scores[i], atol=0.001)    
        end

end
