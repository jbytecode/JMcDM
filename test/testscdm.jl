@testset "Single Criterion Decision Making Functions" verbose = true begin
    @testset "Single Criterion Decision Making tools" verbose = true begin
        @testset "Laplace" begin

            tol = 0.00001

            mat = [
                3000 2750 2500 2250.0
                1500 4750 8000 7750
                2000 5250 8500 11750
            ]

            result = laplace(mat)

            @test isa(result, LaplaceResult)

            @test isapprox(result.expected_values, [2625.0, 5500, 6875], atol = tol)

            @test result.bestIndex == 3
        end


        @testset "Maximin" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = maximin(mat)

            @test isa(result, MaximinResult)

            @test isapprox(result.rowmins, [18, 18, 24, 20], atol = tol)

            @test result.bestIndex == 3
        end


        @testset "Maximax" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = maximax(mat)

            @test isa(result, MaximaxResult)

            @test isapprox(result.rowmaxs, [26, 34, 34, 30], atol = tol)

            @test result.bestIndex in [2, 3]
        end


        @testset "Minimax" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = minimax(mat)

            @test isa(result, MinimaxResult)

            @test isapprox(result.rowmaxs, [26, 34, 34, 30], atol = tol)

            @test result.bestIndex == 1
        end


        @testset "Minimin" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = minimin(mat)

            @test isa(result, MiniminResult)

            @test isapprox(result.rowmins, [18, 18, 24, 20], atol = tol)

            @test result.bestIndex in [1, 2]
        end



        @testset "Savage" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = savage(mat)

            @test isa(result, SavageResult)

            @test result.bestIndex == 4

        end


        @testset "Hurwicz" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            result = hurwicz(mat)

            @test isa(result, HurwiczResult)

            @test result.bestIndex == 3

        end



        @testset "Maximum likelihood for single criterion" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            weights = [0.2, 0.5, 0.2, 0.1]

            result = mle(mat, weights)

            @test isa(result, MLEResult)

            @test result.bestIndex == 2

            @test isapprox(
                result.scores,
                [24.0, 29.2, 27.000000000000004, 27.0],
                atol = tol,
            )
        end



        @testset "Expected Regret" begin

            tol = 0.00001

            mat = [
                26 26 18 22.0
                22 34 30 18
                28 24 34 26
                22 30 28 20
            ]

            weights = [0.2, 0.5, 0.2, 0.1]


            result = expectedregret(mat, weights)

            @test isa(result, ExpectedRegretResult)

            @test result.bestIndex == 2

            @test isapprox(result.scores, [8, 2.8, 5, 5], atol = tol)
        end
    end
end
