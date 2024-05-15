using Test

@testset "MCDM with Grey Numbers" verbose = true begin

    @testset "Topsis with Grey Numbers" begin
        atol = 0.001
        decmat = [
            GreyNumber(1.0, 2.0) GreyNumber(2.0, 3.0) GreyNumber(3.0, 4.0);
            GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0) GreyNumber(3.0, 4.0);
            GreyNumber(3.0, 4.0) GreyNumber(2.0, 3.0) GreyNumber(1.0, 2.0);
        ]
        w = [0.5, 0.4, 0.1]
        fns = [maximum, maximum, minimum]


        result = topsis(decmat, w, fns)
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
        fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]

        df = Amat |> makegrey

        result = vikor(df, w, fns)

        @test isa(result, VikorResult)
        @test result.bestIndex == 4

        @test isapprox(result.scores[1].a, 0.74, atol = tol)
        @test isapprox(result.scores[2].a, 0.73, atol = tol)
        @test isapprox(result.scores[3].a, 1.0, atol = tol)
        @test isapprox(result.scores[4].a, 0.0, atol = tol)
    end


    @testset "Aras with Grey Numbers" begin
        tol = 0.0001

        decmat = hcat(
            [105000.0, 120000, 150000, 115000, 135000],
            [105.0, 110, 120, 105, 115],
            [10.0, 15, 12, 20, 15],
            [4.0, 4, 3, 4, 5],
            [300.0, 500, 550, 600, 400],
            [10.0, 8, 12, 9, 9]
        )
        functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

        w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

        gdf = decmat |> makegrey
        result = aras(gdf, w, functionlist)
        @test isa(result, ARASResult)

        knownscores = [
            GreyNumber(0.81424068),
            GreyNumber(0.89288620),
            GreyNumber(0.76415790),
            GreyNumber(0.84225462),
            GreyNumber(0.86540635),
        ]


        for i = eachindex(knownscores)
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


        df = decmat |> makegrey

        weights = [0.036, 0.192, 0.326, 0.326, 0.120]

        lambda = 0.5

        fns = [maximum, minimum, maximum, maximum, maximum]

        result = cocoso(df, weights, fns, lambda = lambda)

        @test result isa CoCoSoResult

        knownscores = [
            GreyNumber(2.0413128390265998),
            GreyNumber(2.787989783418825),
            GreyNumber(2.8823497955972495),
            GreyNumber(2.4160457689259287),
            GreyNumber(1.2986918936013303),
            GreyNumber(1.4431429073391682),
            GreyNumber(2.519094173200623),
        ]

        for i = eachindex(knownscores)
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

        df = decmat |> makegrey

        w = [0.036, 0.192, 0.326, 0.326, 0.12]
        fns = [maximum, minimum, maximum, maximum, maximum]

        result = codas(df, w, fns)
        @test result isa CODASResult
        knownscores = [
            GreyNumber(0.512176491),
            GreyNumber(1.463300035),
            GreyNumber(1.07153259),
            GreyNumber(-0.212467998),
            GreyNumber(-1.851520552),
            GreyNumber(-1.17167677),
            GreyNumber(0.188656204),
        ]

        for i = eachindex(knownscores)
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

        df = decmat |> makegrey

        weights = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667]

        fns = [maximum, maximum, maximum, maximum, maximum, minimum]

        result = copras(df, weights, fns)
        @test result isa COPRASResult
        knownscores = [
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
            GreyNumber(1.00000),
        ]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end


    @testset "EDAS with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            5000 5 5300 450.0
            4500 5 5000 400
            4500 4 4700 400
            4000 4 4200 400
            5000 4 7100 500
            5000 5 5400 450
            5500 5 6200 500
            5000 4 5800 450
        ]

        df = decmat |> makegrey

        weights = [0.25, 0.25, 0.25, 0.25]

        fns = [maximum, maximum, minimum, minimum]

        result = edas(df, weights, fns)
        @test result isa EDASResult
        knownscores = [
            GreyNumber(0.759594),
            GreyNumber(0.886016),
            GreyNumber(0.697472),
            GreyNumber(0.739658),
            GreyNumber(0.059083),
            GreyNumber(0.731833),
            GreyNumber(0.641691),
            GreyNumber(0.385194),
        ]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end

    end


    @testset "MABAC with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            2 1 4 7 6 6 7 3000.0
            4 1 5 6 7 7 6 3500
            3 2 6 6 5 6 8 4000
            5 1 5 7 6 7 7 3000
            4 2 5 6 7 7 6 3000
            3 2 6 6 6 6 6 3500
        ]

        df = decmat |> makegrey

        weights = [0.293, 0.427, 0.067, 0.027, 0.053, 0.027, 0.053, 0.053]

        fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum]

        result = mabac(df, weights, fns)
        @test result isa MABACResult
        knownscores = [
            GreyNumber(-0.31132),
            GreyNumber(-0.10898),
            GreyNumber(0.20035),
            GreyNumber(0.04218),
            GreyNumber(0.34452),
            GreyNumber(0.20035),
        ]
        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end


    @testset "MAIRCA with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            6.952 8.000 6.649 7.268 8.000 7.652 6.316
            7.319 7.319 6.604 7.319 8.000 7.652 5.313
            7.000 7.319 7.652 6.952 7.652 6.952 4.642
            7.319 6.952 6.649 7.319 7.652 6.649 5.000
        ]

        df = decmat |> makegrey

        weights = [0.172, 0.165, 0.159, 0.129, 0.112, 0.122, 0.140]

        fns = [maximum, maximum, maximum, maximum, maximum, maximum, minimum]

        result = mairca(df, weights, fns)
        @test result isa MAIRCAResult
        knownscores = [
            GreyNumber(0.1206454),
            GreyNumber(0.0806646),
            GreyNumber(0.1458627),
            GreyNumber(0.1454237),
        ]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end

    end


    @testset "MARCOS with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            8.675 8.433 8.000 7.800 8.025 8.043
            8.825 8.600 7.420 7.463 7.825 8.229
            8.325 7.600 8.040 7.700 7.925 7.600
            8.525 8.667 7.180 7.375 7.750 8.071
        ]

        df = decmat |> makegrey

        weights = [0.19019, 0.15915, 0.19819, 0.19019, 0.15115, 0.11111]

        fns = [maximum, maximum, maximum, maximum, maximum, maximum]

        Fns = convert(Array{Function,1}, fns)

        result = marcos(df, weights, Fns)
        @test result isa MarcosResult
        knownscores = [
            GreyNumber(0.684865943528),
            GreyNumber(0.67276710669),
            GreyNumber(0.6625969061),
            GreyNumber(0.6611032076),
        ]
        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end


    @testset "MOORA with Grey Numbers" begin
        @testset "MOORA Reference with Grey Numbers" begin
            tol = 0.00001
            w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
            Amat = [
                100 92 10 2 80 70 95 80.0
                80 70 8 4 100 80 80 90
                90 85 5 0 75 95 70 70
                70 88 20 18 60 90 95 85
            ]
            dmat = Amat |> makegrey

            fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum]
            result = moora(dmat, w, fns)

            @test isa(result, MooraResult)

            knownscores = [
                GreyNumber(0.33159387),
                GreyNumber(0.29014464),
                GreyNumber(0.37304311),
                GreyNumber(0.01926526),
            ]

            for i = eachindex(knownscores)
                @test isapprox(result.scores[i], knownscores[i], atol = tol)
            end
        end

        @testset "MOORA Ratio" begin
            tol = 0.001
            w = [0.20, 0.1684, 0.1579, 0.1474, 0.1158, 0.0842, 0.0737, 0.0421, 0.0105]
            fns = [
                minimum,
                minimum,
                maximum,
                maximum,
                maximum,
                maximum,
                maximum,
                maximum,
                minimum,
            ]
            mat = [
                168000 4.2 35 5 5 5 5 136 109
                179697 4.1 34.5 5 4 4 5 190 107
                140600 4.5 33 3 3 3 3 150 119
                134950 4.3 28 3 2 4 4 190 112
                151980 5.6 35 3 4 4 3 170 147
                181632 4 35 5 3 4 5 190 106
                160620 4.8 33 2 3 3 2 180 125
                162900 4.5 35.4 3 4 3 2 143 119
                178000 4.2 32 2 3 2 3 180 110
            ]

            df = mat |> makegrey

            result = moora(df, w, fns, method = :ratio)

            @test result isa MooraResult
            @test isapprox(GreyNumber(0.13489413914936565), result.scores[1], atol = tol)
            @test isapprox(GreyNumber(0.11647832078367353), result.scores[2], atol = tol)
            @test isapprox(GreyNumber(0.0627565796439602), result.scores[3], atol = tol)
            @test isapprox(GreyNumber(0.06656348556629459), result.scores[4], atol = tol)
            @test isapprox(GreyNumber(0.06687625630547807), result.scores[5], atol = tol)
            @test isapprox(GreyNumber(0.10685768975933238), result.scores[6], atol = tol)
            @test isapprox(GreyNumber(0.03301387703317765), result.scores[7], atol = tol)
            @test isapprox(GreyNumber(0.06114965130074492), result.scores[8], atol = tol)
            @test isapprox(GreyNumber(0.031152492476171283), result.scores[9], atol = tol)
        end
    end

    @testset "MOOSRA with Grey Numbers" begin
        tol = 0.0001

        decmat = hcat(
            [25.0, 21, 19, 22],
            [65.0, 78, 53, 25],
            [7.0, 6, 5, 2],
            [20.0, 24, 33, 31],
        )
        weights = [0.25, 0.25, 0.25, 0.25]
        fns = [maximum, maximum, minimum, maximum]

        mydf = decmat |> makegrey

        result = moosra(mydf, weights, fns)

        @test result isa MoosraResult

        knownscores = [
            GreyNumber(15.714285714285714),
            GreyNumber(20.499999999999996),
            GreyNumber(20.999999999999996),
            GreyNumber(39.000000000000000),
        ]

        @test result.rankings == [1, 2, 3, 4]
        @test result.bestIndex == 4
        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end


    @testset "PSI with Grey Numbers" begin
        tol = 0.0001

        decmat = hcat(
            Float64[9, 8, 7],
            Float64[7, 7, 8],
            Float64[6, 9, 6],
            Float64[7, 6, 6],
        )

        w = Float64[4, 2, 6, 8]

        fns = [maximum, maximum, maximum, maximum]

        mydf = decmat |> makegrey

        result = psi(mydf, fns)

        @test result isa PSIResult
        @test result.bestIndex == 2
        knownscores = [
            GreyNumber(1.1487059780663555),
            GreyNumber(1.252775986851622),
            GreyNumber(1.0884916686098811),
        ]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end

    end


    @testset "ROV with Grey Numbers" begin
        tol = 0.01
        mat = [
            0.035 34.5 847 1.76 0.335 0.5 0.59 0.59
            0.027 36.8 834 1.68 0.335 0.665 0.665 0.665
            0.037 38.6 808 2.4 0.59 0.59 0.41 0.5
            0.028 32.6 821 1.59 0.5 0.59 0.59 0.41
        ]

        df = mat |> makegrey

        w = [0.3306, 0.0718, 0.1808, 0.0718, 0.0459, 0.126, 0.126, 0.0472]

        fns = [minimum, minimum, minimum, minimum, maximum, minimum, minimum, maximum]

        result = rov(df, w, fns)

        @test result isa ROVResult

        knownscores = [
            GreyNumber(0.1841453340595497),
            GreyNumber(0.26171444444444447),
            GreyNumber(0.21331577540106955),
            GreyNumber(0.34285244206773624),
        ]

        @test result.ranks == [4, 2, 3, 1]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end



    @testset "SAW with Grey Numbers" begin

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

            mydf = decmat |> makegrey

            result = saw(mydf, weights, fns)

            @test result isa SawResult

            knownscores = [
                GreyNumber(0.681277),
                GreyNumber(0.725151),
                GreyNumber(0.709871),
                GreyNumber(0.784976),
            ]

            for i = eachindex(knownscores)
                @test isapprox(result.scores[i], knownscores[i], atol = tol)
            end
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

            df = decmat |> makegrey

            weights = [0.283, 0.162, 0.162, 0.07, 0.085, 0.162, 0.076]
            fns = [maximum for i = 1:7]
            result = saw(df, weights, fns)

            @test result isa SawResult
            knownscores = [
                GreyNumber(0.553228),
                GreyNumber(0.713485),
                GreyNumber(0.837428),
                GreyNumber(0.514657),
                GreyNumber(0.579342),
            ]
            @test result.bestIndex == 3
            @test result.ranking == [3, 2, 5, 1, 4]

            for i = eachindex(knownscores)
                @test isapprox(result.scores[i], knownscores[i], atol = tol)
            end
        end
    end


    @testset "WASPAS with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            3 12.5 2 120 14 3
            5 15 3 110 38 4
            3 13 2 120 19 3
            4 14 2 100 31 4
            3 15 1.5 125 40 4
        ]

        df = decmat |> makegrey

        weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

        fns = [maximum, minimum, minimum, maximum, minimum, maximum]

        result = waspas(df, weights, fns)
        @test result isa WASPASResult

        knownscores = [
            GreyNumber(0.805021),
            GreyNumber(0.775060),
            GreyNumber(0.770181),
            GreyNumber(0.796424),
            GreyNumber(0.788239),
        ]

        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end


    @testset "WPM with Grey Numbers" begin
        tol = 0.0001
        decmat = [
            3 12.5 2 120 14 3
            5 15 3 110 38 4
            3 13 2 120 19 3
            4 14 2 100 31 4
            3 15 1.5 125 40 4
        ]

        df = decmat |> makegrey

        weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

        fns = [maximum, minimum, minimum, maximum, minimum, maximum]

        result = wpm(df, weights, fns)
        @test result isa WPMResult
        knownscores = [
            GreyNumber(0.7975224331331),
            GreyNumber(0.7532541470585),
            GreyNumber(0.7647463553356),
            GreyNumber(0.7873956894791),
            GreyNumber(0.7674278741782),
        ]
        for i = eachindex(knownscores)
            @test isapprox(result.scores[i], knownscores[i], atol = tol)
        end
    end

end
