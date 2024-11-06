@testset "IDOCRIW Tests" verbose = true begin

    @testset "Zavadskas & Podvezko Paper Example" begin
        decmat = Float64[
            3 100 10 7;
            2.5 80 8 5;
            1.8 50 20 11;
            2.2 70 12 9
        ]

        
        cilos_w = Float64[0.3343, 0.2199, 0.1957, 0.2501]

        entropy_w = Float64[0.1146, 0.1981, 0.4185, 0.2689]
        
        idowric_w = Float64[0.1658, 0.1886, 0.3545, 0.2911]

        dirs = [minimum, maximum, minimum, maximum]

        result = idocriw(decmat, dirs)

        @test result isa IDOCRIWResult
        
        @test isapprox(result.cilos_weight, cilos_w, atol=0.01)
        
        @test isapprox(result.entropy_weight, entropy_w, atol=0.01)

        @test isapprox(result.weights, idowric_w, atol=0.01)

    end
end