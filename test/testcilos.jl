@testset "Cilos Tests" verbose = true begin

    @testset "Zavadskas & Podvezko Paper Example" begin
        decmat = Float64[
            3 100 10 7;
            2.5 80 8 5;
            1.8 50 20 11;
            2.2 70 12 9
        ]

        normalizedmatrix = Float64[
            0.191 0.333 0.279 0.219;
            0.229 0.267 0.349 0.156;
            0.319 0.167 0.140 0.344;
            0.261 0.233 0.233 0.281
        ]

        A = Float64[0.319 0.167 0.140 0.344;
            0.191 0.333 0.279 0.219;
            0.229 0.267 0.349 0.156;
            0.319 0.167 0.140 0.344]

        P = Float64[
            0.0000 0.5000 0.6000 0.0000;
            0.4000 0.0000 0.2000 0.3636;
            0.2800 0.2000 0.0000 0.5455;
            0.0000 0.5000 0.6000 0.0000
        ]

        F = Float64[
            -0.6800 0.5000  0.6000  0.0000;
            0.4000  -1.2000 0.2000  0.3636;
            0.2800  0.2000  -1.4000 0.5455;
            0.0000  0.5000  0.6000  -0.9091
        ]

        w = Float64[0.3343, 0.2199, 0.1957, 0.2501]

        dirs = [minimum, maximum, minimum, maximum]

        result = cilos(decmat, dirs)

        @test result isa CILOSResult
        @test isapprox(result.normalizedmatrix, normalizedmatrix, atol=0.01)

        @test result.highestvaluerows == [3, 1, 2, 3]

        @test isapprox(result.A, A, atol=0.01)

        @test isapprox(result.P, P, atol=0.01)

        @test isapprox(result.F, F, atol=0.01)

        @test isapprox(result.weights, w, atol=0.01)

    end
end