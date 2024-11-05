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