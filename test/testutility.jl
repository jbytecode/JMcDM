@testset "Utility functions" begin
    @testset "Identity matrix" begin
        @test JMcDM.I(2) == [1.0 0; 0 1]
        @test JMcDM.I(3) == [1.0 0 0; 0 1 0; 0 0 1]
        @test JMcDM.I(4) == [1.0 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
    end

    @testset "mean" begin
        @test JMcDM.mean([1.0, 2.0, 3.0]) == 2.0
        @test JMcDM.mean([1.0, 2.0, 3.0, 4.0]) == 2.5
    end

    @testset "var" begin
        @test JMcDM.var([1.0, 2.0, 3.0]) == 1.0
        @test isapprox(JMcDM.var([1.0, 2.0, 3.0, 4.0]), 1.666667, atol = 0.001)
    end

    @testset "std" begin
        @test JMcDM.std([1.0, 2.0, 3.0]) == 1.0
        @test isapprox(JMcDM.std([1.0, 2.0, 3.0, 4.0]), 1.290994, atol = 0.001)
    end

    @testset "geomean" begin
        @test isapprox(JMcDM.geomean([1.0, 2.0, 3.0]), 1.817121, atol = 0.001)
        @test isapprox(JMcDM.geomean([1.0, 2.0, 3.0, 4.0]), 2.213364, atol = 0.001)
    end

    @testset "cor" begin
        x = [1.0, 2.0, 3.0, 4.0, 5.0]
        y = [5.0, 4.0, 3.0, 2.0, 1.0]
        @test JMcDM.cor(x, x) == 1.0
        @test JMcDM.cor(x, y) == -1.0

        mat = hcat(x, y)
        cormat = JMcDM.cor(mat)
        @test cormat[1, 1] == 1.0
        @test cormat[1, 2] == -1.0
        @test cormat[2, 1] == -1.0
        @test cormat[2, 2] == 1.0
    end

    @testset "Euclidean distance" begin
        @test euclidean([0.0, 1.0, 2.0], [0.0, 1.0, 2.0]) == 0.0
        @test euclidean([0.0, 0.0, 0.0]) == 0.0
        @test euclidean([0.0, 0.0, 1.0]) == 1.0
        @test euclidean([0.0, 0.0, 1.0], [0.0, 0.0, 2.0]) == 1.0
        @test euclidean([0, 0, 0]) == 0.0
        @test euclidean([0, 0, 0, 0], [1, 0, 0, 0]) == 1.0
        @test euclidean([0, 0, 0, 0], [1, 0, 0, 0]) isa Float64
        @test euclidean([0, 0, 0, 0], [1.0, 0, 0, 0]) isa Float64
    end

    @testset "Normalization" begin
        tol = 0.00001
        nz = normalize([1.0, 2.0, 3.0, -1.0, 0.0])
        @test isapprox(nz[1], 0.2581989, atol = tol)
        @test isapprox(nz[2], 0.5163978, atol = tol)
        @test isapprox(nz[3], 0.7745967, atol = tol)
        @test isapprox(nz[4], -0.2581989, atol = tol)
        @test isapprox(nz[5], 0.0000000, atol = tol)

        nzint = normalize([1, 2, 3, -1, 0])
        @test isapprox(nzint[1], 0.2581989, atol = tol)
        @test isapprox(nzint[2], 0.5163978, atol = tol)
        @test isapprox(nzint[3], 0.7745967, atol = tol)
        @test isapprox(nzint[4], -0.2581989, atol = tol)
        @test isapprox(nzint[5], 0.0000000, atol = tol)
    end

    
    @testset "Unitize vector" begin
        x = [1.0, 2.0, 3.0, 4.0, 5.0]
        result = x |> unitize |> sum
        @test result == 1.0

        x = [1, 2, 3, 4, 5]
        result = x |> unitize |> sum
        @test result == 1.0

        x = [1, 1, 1, 1, 1]
        result = x |> unitize
        @test result == [0.20, 0.20, 0.20, 0.20, 0.20]

        x = [0.20, 0.20, 0.20, 0.20, 0.20]
        result = x |> unitize
        @test result == [0.20, 0.20, 0.20, 0.20, 0.20]
    end


    @testset "Reverse minimum & maximum array" begin

        fns = [minimum, maximum, maximum, minimum, maximum]
        revfns = [maximum, minimum, minimum, maximum, minimum]

        @test reverseminmax(fns) == revfns

        @test reverseminmax(revfns) == fns
    end

    @testset "Make Array of minimum and maximum" begin
        result1 = [maximum, maximum, maximum, maximum]

        @test result1 isa Array{F,1} where {F<:Function}

        @test typeof(result1[1]([1.0, 2.0, 3.0])) == Float64

        @test result1[1]([1.0, 2.0, 3.0]) == 3.0

    end

    @testset "Make Grey Matrix" begin
        m = [
            1.0 2 3
            4 5 6
            7 8 9
        ]
        grey = makegrey(m)
        @test grey[1, 1] == GreyNumber(1.0, 1.0)
        @test grey[1, 2] == GreyNumber(2.0, 2.0)
        @test grey[1, 3] == GreyNumber(3.0, 3.0)
        @test grey[2, 1] == GreyNumber(4.0, 4.0)
        @test grey[2, 2] == GreyNumber(5.0, 5.0)
        @test grey[2, 3] == GreyNumber(6.0, 6.0)
        @test grey[3, 1] == GreyNumber(7.0, 7.0)
        @test grey[3, 2] == GreyNumber(8.0, 8.0)
        @test grey[3, 3] == GreyNumber(9.0, 9.0)
    end
end
