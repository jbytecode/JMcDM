using Test

@testset "MCDM with Grey Numbers" begin

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
        for i = 1:n
            for j = 1:p
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


    @testset "Aras with Grey Numbers" begin 
        tol = 0.0001

        df = DataFrame(
            :K1 => [105000.0, 120000, 150000, 115000, 135000],
            :K2 => [105.0, 110, 120, 105, 115],
            :K3 => [10.0, 15, 12, 20, 15],
            :K4 => [4.0, 4, 3, 4, 5],
            :K5 => [300.0, 500, 550, 600, 400],
            :K6 => [10.0, 8, 12, 9, 9],
        )
        functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

        w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

        gdf = df |> Matrix |> makegrey |> makeDecisionMatrix 
        result = aras(gdf, w, functionlist)
        @test isa(result, ARASResult)
        
        knownscores = 
            [
            GreyNumber(0.81424068), 
            GreyNumber(0.89288620), 
            GreyNumber(0.76415790), 
            GreyNumber(0.84225462), 
            GreyNumber(0.86540635)
            ]
        

        for i in 1:length(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end 
        
        @test result.bestIndex == 2
        @test result.orderings == [3, 1, 4, 5, 2]
    end


    @testset "COCOSO with Grey Numbers" begin 
        tol = 0.0001
        decmat = [
            60.00 0.40 2540.00 500.00 990.00
            6.35 0.15 1016.00 3000.00 1041.00
            6.80 0.10 1727.20 1500.00 1676.00
            10.00 0.20 1000.00 2000.00 965.00
            2.50 0.10 560.00 500.00 915.00
            4.50 0.08 1016.00 350.00 508.00
            3.00 0.10 1778.00 1000.00 920.00
        ]


        df = decmat |> makegrey |> makeDecisionMatrix

        weights = [0.036, 0.192, 0.326, 0.326, 0.120]

        lambda = 0.5

        fns = [maximum, minimum, maximum, maximum, maximum]

        result = cocoso(df, weights, fns, lambda = lambda)
        
        @test result isa CoCoSoResult
        
        knownscores = 
            [
                GreyNumber(2.0413128390265998),
                GreyNumber(2.787989783418825),
                GreyNumber(2.8823497955972495),
                GreyNumber(2.4160457689259287),
                GreyNumber(1.2986918936013303),
                GreyNumber(1.4431429073391682),
                GreyNumber(2.519094173200623),
            ]

        for i in 1:length(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end 

    @testset "CODAS with Grey Numbers" begin 
        tol = 0.0001
        decmat = [
            60.000 0.400 2540 500 990
            6.350 0.150 1016 3000 1041
            6.800 0.100 1727.2 1500 1676
            10.000 0.200 1000 2000 965
            2.500 0.100 560 500 915
            4.500 0.080 1016 350 508
            3.000 0.100 1778 1000 920
        ]

        df = decmat |> makegrey |> makeDecisionMatrix

        w = [0.036, 0.192, 0.326, 0.326, 0.12]
        fns = [maximum, minimum, maximum, maximum, maximum]

        result = codas(df, w, fns)
        @test result isa CODASResult
        knownscores = 
            [
                GreyNumber(0.512176491),
                GreyNumber(1.463300035),
                GreyNumber(1.07153259),
                GreyNumber(-0.212467998),
                GreyNumber(-1.851520552),
                GreyNumber(-1.17167677),
                GreyNumber(0.188656204)
            ]

        for i in 1:length(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end 

    end     


    @testset "COPRAS with Grey Numbers" begin 
        tol = 0.0001
        decmat = [
            2.50 240 57 45 1.10 0.333333
            2.50 285 60 75 4.00 0.428571
            4.50 320 100 65 7.50 1.111111
            4.50 365 100 90 7.50 1.111111
            5.00 400 100 90 11.00 1.111111
            2.50 225 60 45 1.10 0.333333
            2.50 270 57 60 4.00 0.428571
            4.50 330 100 70 7.50 1.111111
            4.50 365 100 80 7.50 1.111111
            5.00 380 110 65 8.00 1.111111
            2.50 285 65 80 4.00 0.400000
            4.00 280 75 65 4.00 0.400000
            4.50 365 102 95 7.50 1.111111
            4.50 400 102 95 7.50 1.111111
            6.00 450 110 95 11.00 1.176471
            6.00 510 110 105 11.00 1.176471
            6.00 330 140 110 18.50 1.395349
            2.50 240 65 80 4.00 0.400000
            4.00 280 75 75 4.00 0.400000
            4.50 355 102 95 7.50 1.111111
            4.50 385 102 90 7.50 1.111111
            5.00 385 114 95 7.50 1.000000
            6.00 400 110 90 11.00 1.000000
            6.00 480 110 95 15.00 1.000000
            6.00 440 140 100 18.50 1.200000
            6.00 500 140 100 18.50 1.200000
            5.00 450 125 100 15.00 1.714286
            6.00 500 150 125 18.50 1.714286
            6.00 515 180 140 22.00 2.307692
            7.00 550 200 150 30.00 2.307692
            6.00 500 180 140 15.00 2.307692
            6.00 500 180 140 18.50 2.307692
            6.00 500 180 140 22.00 2.307692
            7.00 500 180 140 30.00 2.307692
            7.00 500 200 140 37.00 2.307692
            7.00 500 200 140 45.00 2.307692
            7.00 500 200 140 55.00 2.307692
            7.00 500 200 140 75.00 2.307692
        ]

        df = decmat |> makegrey |> makeDecisionMatrix

        weights = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667]

        fns = [maximum, maximum, maximum, maximum, maximum, minimum]

        result = copras(df, weights, fns)
        @test result isa COPRASResult
        knownscores = 
            [
                GreyNumber(0.44194),
                GreyNumber(0.44395),
                GreyNumber(0.41042),
                GreyNumber(0.44403),
                GreyNumber(0.48177),
                GreyNumber(0.44074),
                GreyNumber(0.42430),
                GreyNumber(0.41737),
                GreyNumber(0.43474),
                GreyNumber(0.44382),
                GreyNumber(0.46625),
                GreyNumber(0.48602),
                GreyNumber(0.45019),
                GreyNumber(0.45825),
                GreyNumber(0.51953),
                GreyNumber(0.54265),
                GreyNumber(0.56134),
                GreyNumber(0.45588),
                GreyNumber(0.49532),
                GreyNumber(0.44788),
                GreyNumber(0.45014),
                GreyNumber(0.48126),
                GreyNumber(0.51586),
                GreyNumber(0.56243),
                GreyNumber(0.58709),
                GreyNumber(0.60091),
                GreyNumber(0.51850),
                GreyNumber(0.61085),
                GreyNumber(0.65888),
                GreyNumber(0.75650),
                GreyNumber(0.61430),
                GreyNumber(0.63486),
                GreyNumber(0.65542),
                GreyNumber(0.72065),
                GreyNumber(0.77680),
                GreyNumber(0.82379),
                GreyNumber(0.88253),
                GreyNumber(1.00000)
            ]

            for i in 1:length(knownscores)
                @test isapprox(result.scores[i], knownscores[i], atol = tol)
            end
    end 

    
end
