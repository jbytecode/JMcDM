@testset "LP Based Functions (Takes time...)" begin
    @testset "Zero Sum Games" begin
        @testset "Game" begin

            tol = 0.00001

            mat = [
                -2 6 3
                3 -4 7
                -1 2 4
            ]

            dm = makeDecisionMatrix(mat)
            result = game(dm)

            @test isa(result, GameResult)

            @test isapprox(result.value, 0.6666666666666661, atol = tol)

            @test isapprox(
                result.row_player_probabilities,
                [0.4666667, 0.5333333, 0.0000000],
                atol = tol,
            )

        end

        @testset "Game - Rock & Paper & Scissors" begin

            tol = 0.00001

            mat = [
                0 -1 1
                1 0 -1
                -1 1 0
            ]

            dm = makeDecisionMatrix(mat)
            result = game(dm)

            @test isa(result, GameResult)

            @test result.value == 0.0

            @test isapprox(
                result.row_player_probabilities,
                [0.333333, 0.333333, 0.33333],
                atol = tol,
            )

        end

    end # end of zero sum games




    @testset "Data Envelopment" begin

        tol = 0.00001

        x1 = [96.0, 84, 90, 81, 102, 83, 108, 99, 95]
        x2 = [300.0, 282, 273, 270, 309, 285, 294, 288, 306]

        out = [166.0, 150, 140, 136, 171, 144, 172, 170, 165]
        inp = hcat(x1, x2)

        result::DataEnvelopResult = dataenvelop(inp, out)

        @test isa(result, DataEnvelopResult)


        @test result.orderedcases ==
              [:Case8, :Case2, :Case7, :Case1, :Case9, :Case6, :Case5, :Case4, :Case3]

        @test isapprox(
            result.efficiencies,
            [
                0.9879815986198964,
                0.9999999999999999,
                0.8959653733189055,
                0.9421686746987951,
                0.9659435120753173,
                0.9715662650602411,
                0.9911164465786314,
                1.0,
                0.9841048789857857,
            ],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case1],
            [0.0, 0.544106, 0.0, 0.0, 0.0, 0.0, 0.0, 0.496377, 0.0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case2],
            [0.0, 1, 0, 0, 0, 0, 0, 0, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case3],
            [0.0, 0.266193, 0, 0, 0, 0, 0, 0.588654, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case4],
            [0.0, 0.860241, 0, 0, 0, 0, 0, 0.0409639, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case5],
            [0.0, 0.314982, 0, 0, 0, 0, 0, 0.727957, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case6],
            [0.0, 0.96, 0, 0, 0, 0, 0, 0, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case7],
            [0.0, 0, 0, 0, 0, 0, 0, 1.01176, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case8],
            [0.0, 0, 0, 0, 0, 0, 0, 1.0, 0],
            atol = tol,
        )

        @test isapprox(
            result.references[:, :Case9],
            [0.0, 0.774923, 0, 0, 0, 0, 0, 0.286833, 0],
            atol = tol,
        )

    end
end
