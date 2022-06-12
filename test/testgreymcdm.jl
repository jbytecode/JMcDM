using Test


@testset "Topsis with Grey Numbers" begin
    atol = 0.001
    decmat = [
        GreyNumber(1.0, 2.0) GreyNumber(2.0, 3.0) GreyNumber(3.0, 4.0)
        GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0) GreyNumber(3.0, 4.0)
        GreyNumber(3.0, 4.0) GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0)
    ]
    w = [0.5, 0.4, 0.1]
    fns = makeminmax([maximum, maximum, minimum])

    df = makeDecisionMatrix(decmat)

    result = topsis(df, w, fns)
    scores = result.scores 
    @test isapprox(scores[1], GreyNumber(0.23506, 0.83613), atol = atol)
    @test isapprox(scores[2], GreyNumber(0.24317, 1.00294), atol = atol)
    @test isapprox(scores[3], GreyNumber(0.10851, 1.23913), atol = atol)
end


@testset "Grey Vikor with Grey numbers" begin
    tol = 0.01
        w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
        Amat = [
            100 92 10 2 80 70 95 80.0
            80 70 8 4 100 80 80 90
            90 85 5 0 75 95 70 70
            70 88 20 18 60 90 95 85
        ]
        fns = makeminmax([
            maximum,
            maximum,
            maximum,
            maximum,
            maximum,
            maximum,
            maximum,
            maximum,
        ])
        
        n, p = size(Amat)
        dfmat = Matrix{GreyNumber}(undef, n, p)
        for i in 1:n
            for j in 1:p
                dfmat[i, j] = GreyNumber(Float64(Amat[i, j]))
            end 
        end 

        result = vikor(makeDecisionMatrix(dfmat), w, fns)

        @test isa(result, VikorResult)
        @test result.bestIndex == 4

        @test isapprox(result.scores[1].a, 0.74, atol = tol)
        @test isapprox(result.scores[2].a, 0.73, atol = tol)
        @test isapprox(result.scores[3].a, 1.0, atol = tol)
        @test isapprox(result.scores[4].a, 0.0, atol = tol)
end


