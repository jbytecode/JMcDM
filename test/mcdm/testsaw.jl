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