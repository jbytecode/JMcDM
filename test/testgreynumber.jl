@testset "Test GreyNumbers" begin

    @testset "Plus operator" begin 
        @test GreyNumber(1, 1) + GreyNumber(5, 2) == GreyNumber(3, 6)
        @test GreyNumber(6, 5) + GreyNumber(6, 5) == GreyNumber(10, 12)
        @test GreyNumber(2, 3) + 5 == GreyNumber(7, 8)
        @test 5 + GreyNumber(2, 3) == GreyNumber(7, 8)
    end 

    @testset "Minus operator" begin 
        @test GreyNumber(1, 1) - GreyNumber(5, 2) == GreyNumber(-4, -1)
        @test GreyNumber(6, 5) - GreyNumber(6, 5) == GreyNumber(-1, 1)
        @test GreyNumber(2, 3) - 5 == GreyNumber(-3, -2)
        @test 5 - GreyNumber(2, 3) == GreyNumber(2, 3)
    end

    @testset "Asterix operator" begin 
        @test GreyNumber(1, 2) * GreyNumber(3, 4) == GreyNumber(3, 8)
        @test GreyNumber(2, 3) * -1 == GreyNumber(-3, -2)
        @test 10 * GreyNumber(5, 6) == GreyNumber(50, 60)
    end 

    @testset "Division operator" begin 
        @test GreyNumber(10, 50) / GreyNumber(2, 5) == GreyNumber(2, 25)
        @test 1 / GreyNumber(10, 100) == GreyNumber(0.01, 0.1)
        @test GreyNumber(10, 100) / 10 == GreyNumber(1, 10)
    end 

     @testset "one and ones" begin
        @test one(GreyNumber) == GreyNumber(1.0, 1.0)
        @test ones(GreyNumber, 2) == [GreyNumber(1), GreyNumber(1)]
    end

    @testset "zero and zeros" begin
        @test zero(GreyNumber) == GreyNumber(0, 0)
        @test zeros(GreyNumber, 2) == [GreyNumber(0), GreyNumber(0)]
    end

    @testset "eltype" begin
        @test eltype(GreyNumber(1.0, 2.0)) == Float64
        @test eltype([GreyNumber(4), GreyNumber(5)]) == GreyNumber 
        @test eltype(GreyNumber) == GreyNumber 
    end

end 