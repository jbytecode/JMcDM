@testset "Trapezoidal  Fuzzy Numbers" verbose = true begin

    @testset "Constructor" begin

        #@test_throws AssertionError Trapezoidal(5, 4, 3, 2)
        #@test_throws AssertionError Trapezoidal(5, 1, 3, 2)
        #@test_throws AssertionError Trapezoidal(5, 4, 6, 2)

        @test Trapezoidal([1, 2, 3, 4]) == Trapezoidal(1, 2, 3, 4)

    end


    @testset "Equality of Trapezoidal " begin
        @test Trapezoidal(1, 2, 3, 6) == Trapezoidal(1, 2, 3, 6)

        t1 = Trapezoidal(6, 8, 12, 13)
        @test isequal(t1, t1)

    end

    @testset "Sum of two Trapezoidal " begin

        t1 = Trapezoidal(1, 2, 3, 4)
        t2 = Trapezoidal(2, 5, 7, 9)

        result = t1 + t2

        @test result == Trapezoidal(3, 7, 10, 13)
    end

    @testset "Diff of Trapezoidal " begin

        t1 = Trapezoidal(1, 2, 3, 4)
        t2 = Trapezoidal(2, 5, 7, 9)

        result = t2 - t1

        @test result == Trapezoidal(-2, 2, 5, 8)

    end


    @testset "Multiply by scalar" begin
        result1 = Trapezoidal(4, 6, 7, 9) * 10
        @test result1.a == 40
        @test result1.b == 60
        @test result1.c == 70
        @test result1.d == 90

        result2 = 10 * Trapezoidal(4, 6, 7, 9)
        @test result2.a == 40
        @test result2.b == 60
        @test result2.c == 70
        @test result2.d == 90
    end


    @testset "Inverse of Trapezoidal " begin
        t = Trapezoidal(2, 3, 4, 5)

        result = inv(t)

        @test result.a == 1 / 5
        @test result.b == 1 / 4
        @test result.c == 1 / 3
        @test result.d == 1 / 2
    end


    @testset "Multiply two Trapezoidal " begin
        t1 = Trapezoidal(1, 4, 6, 9)
        t2 = Trapezoidal(6, 8, 9, 10)

        result = t1 * t2
        resultother = t2 * t1

        @test result == Trapezoidal(6, 32, 54, 90)
        @test result == resultother
    end

    @testset "Division of two Trapezoidal " begin

        t1 = Trapezoidal(1, 4, 6, 9)
        t2 = Trapezoidal(6, 8, 9, 10)

        result = t1 / t2

        @test isapprox(
            result,
            Trapezoidal(0.1, 0.4444444444444444, 0.75, 1.5),
            atol = 0.001,
        )
    end

    @testset "Euclidean distance" begin
        eps = 0.00001

        t1 = Trapezoidal(0, 0, 3, 4)

        @test Fuzzy.euclidean(t1, t1) == 0.0
        @test isapprox(Fuzzy.euclidean(t1), 2.5, atol = eps)
    end

    @testset "Observe" begin
        f = Trapezoidal(1, 2, 5, 11)

        @test observe(f, 0) == 0
        @test observe(f, 1.5) == 0.5
        @test observe(f, 3) == 1
        @test observe(f, 4) == 1
        @test observe(f, 6) == 0.8333333333333334
        @test observe(f, 23412) == 0
    end

    @testset "Length" begin
        @test length(Trapezoidal) == 1
    end

    @testset "First" begin
        @test Trapezoidal(1, 2, 3, 5) |> first == 1
        @test Trapezoidal(2, 3, 4, 5) |> first == 2
    end

    @testset "Last" begin
        @test Trapezoidal(1, 2, 3, 5) |> last == 5
        @test Trapezoidal(2, 3, 4, 6) |> last == 6
    end

    @testset "Zero" begin
        @test zero(Trapezoidal) == Trapezoidal(0, 0, 0, 0)
    end

    @testset "One" begin
        @test one(Trapezoidal) == Trapezoidal(1, 1, 1, 1)
    end

    @testset "Zeros" begin
        v = zeros(Trapezoidal, 10)

        @test v isa Vector{Trapezoidal}
        @test length(v) == 10
        @test v[1] == zero(Trapezoidal)
    end


    @testset "Random" begin

        fnum = rand(Trapezoidal)
        @test fnum.a <= fnum.b <= fnum.c <= fnum.d

        v = rand(Trapezoidal, 5)
        @test length(v) == 5
        @test v[1] isa Trapezoidal

        m = rand(Trapezoidal, 4, 5)
        @test m isa Matrix
        @test m[1, 1] isa Trapezoidal
        @test size(m) == (4, 5)
    end

    @testset "Get index, aka []" begin

        t = Trapezoidal(1, 6, 15, 24)

        @test t[1] == 1
        @test t[2] == 6
        @test t[3] == 15
        @test t[4] == 24

        @test_throws BoundsError t[5]
    end

    @testset "Arity" begin

        @test arity(Trapezoidal) == 4

    end


    @testset "iterator" begin

        f = Trapezoidal(4, 6, 10, 17)

        emptylist = Int64[]

        for a in f
            push!(emptylist, a)
        end

        @test emptylist[1] == 4
        @test emptylist[2] == 6
        @test emptylist[3] == 10
        @test emptylist[4] == 17
    end

end
