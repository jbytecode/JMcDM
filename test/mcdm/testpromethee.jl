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
