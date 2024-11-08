@testset "Best-Worst" verbose = true begin 

    @testset "Basic Example in the Original Paper" begin 

        eps = 0.01 

        pref_to_best = [8, 2, 1]

        pref_to_worst = [1, 5, 8]

        result = bestworst(pref_to_best, pref_to_worst)

        @test isapprox(result.ε, 0.26, atol = eps)

        @test isapprox(result.weights, [0.071, 0.338, 0.589], atol = eps)
    end 


end 