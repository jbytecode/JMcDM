@testset "Utility and Printing Functions" begin
    @testset "Pretty printing of results" begin
        @testset "Pretty printing of TopsisResult" begin
            t = TopsisResult(
                DataFrame(rand(3, 4), :auto),
                rand(3),
                DataFrame(rand(3, 4), :auto),
                DataFrame(rand(3, 4), :auto),
                1,
                [1, 2, 3],
            )
            io = IOBuffer()
            show(io, t)
            str_expected = String(take!(io))
            @test str_expected == "Scores:\n[1.0, 2.0, 3.0]\nBest indices:\n1\n"
        end

        @testset "Pretty printing of ARAS Result" begin
            t = ARASResult(
                rand(3),
                rand(3, 3),
                rand(3, 3),
                rand(3),
                [1.0, 2.0, 3.0],
                [3, 2, 1],
                2,
            )
            io = IOBuffer()
            show(io, t)
            str_expected = String(take!(io))
            @test str_expected ==
                  "Scores:\n[1.0, 2.0, 3.0]\nOrderings: \n[3, 2, 1]\nBest indices:\n2\n"
        end
    end

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

        @testset "Column min and max vectors" begin
            df = DataFrame()
            df[:, :x] = [0.0, 1.0, 10.0]
            df[:, :y] = [0.0, -1.0, -10.0]
            @test colmins(df) == [0.0, -10.0]
            @test colmaxs(df) == [10.0, 0.0]
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

        @testset "Product weights with DataFrame" begin
            df = DataFrame()
            df[:, :x] = [1.0, 2.0, 4.0, 8.0]
            df[:, :y] = [10.0, 20.0, 30.0, 40.0]
            w = [0.60, 0.40]
            result = w * df
            @test result[:, :x] == [0.6, 1.2, 2.4, 4.8]
            @test result[:, :y] == [4.0, 8.0, 12.0, 16.0]

            dfint = DataFrame()
            dfint[:, :x] = [1, 2, 4, 8]
            dfint[:, :y] = [10, 20, 30, 40]
            w = [0.60, 0.40]
            result = w * dfint
            @test result[:, :x] == [0.6, 1.2, 2.4, 4.8]
            @test result[:, :y] == [4.0, 8.0, 12.0, 16.0]
        end

        @testset "Make Decision Matrix" begin
            m = rand(5, 10)
            df = makeDecisionMatrix(m)

            @test isa(df, DataFrame)
            @test size(df) == (5, 10)
            @test df[:, 1] isa Array{Float64,1}
            @test df[:, 2] isa Array{Float64,1}
            @test df[:, 3] isa Array{Float64,1}
            @test df[:, 4] isa Array{Float64,1}
            @test df[:, 5] isa Array{Float64,1}

            @test names(df)[1] == "Crt1"
            @test names(df)[2] == "Crt2"

            m = rand(3, 5)
            dfwithnames = makeDecisionMatrix(m, names = ["A1", "B", "CD", "EE", "FG"])
            @test names(dfwithnames)[1] == "A1"
            @test names(dfwithnames)[2] == "B"
            @test names(dfwithnames)[3] == "CD"
            @test names(dfwithnames)[4] == "EE"
            @test names(dfwithnames)[5] == "FG"
        end


        @testset "Reverse minimum & maximum array" begin

            fns = [minimum, maximum, maximum, minimum, maximum]
            revfns = [maximum, minimum, minimum, maximum, minimum]

            @test reverseminmax(fns) == revfns

            @test reverseminmax(revfns) == fns
        end

        @testset "Make Array of minimum and maximum" begin
            result1 = makeminmax([maximum, maximum, maximum, maximum])

            @test typeof(result1) == Array{Function,1}

            @test typeof(result1[1]([1.0, 2.0, 3.0])) == Float64

            @test result1[1]([1.0, 2.0, 3.0]) == 3.0

        end
    end
end
