@testset "Defuzzification" verbose = true begin


    @testset "The weighted maximum (WM) functional" begin
        t = Trapezoidal(1, 2, 3, 4)
        @test defuzzification(t, WeightedMaximum(0.5)) == 2.5
        @test defuzzification(t, WeightedMaximum(0.75)) == 0.75 * 2 + 0.25 * 3
    end

    @testset "The first maximum (FM) functional" begin
        t = Trapezoidal(1, 2, 3, 4)
        @test defuzzification(t, FirstMaximum()) == 2
    end

    @testset "The last maximum (LM) functional" begin
        t = Trapezoidal(1, 2, 3, 4)
        @test defuzzification(t, LastMaximum()) == 3
    end

    @testset "The middle maximum (MM) functional" begin
        t = Trapezoidal(1, 2, 3, 4)
        @test defuzzification(t, MiddleMaximum()) == 2.5
    end

    @testset "The gravity center (GC) functional" begin
        t = Trapezoidal(1, 10, 50, 100)
        @test defuzzification(t, GravityCenter()) == 41.700239808153476

        @test defuzzification(Trapezoidal(1, 1, 1, 1), GravityCenter()) == 1
    end

    @testset "The geometrical mean (GM) functional" begin
        t = Trapezoidal(1, 10, 50, 100)
        @test defuzzification(t, GeometricMean()) == 35.89928057553957

        @test defuzzification(Trapezoidal(1, 1, 1, 1), GeometricMean()) == 1
    end

    @testset "Triangular" begin
        t1 = Trapezoidal(1, 50, 50, 100)
        t2 = Triangular(1, 50, 100)

        @test defuzzification(t1, GeometricMean()) == defuzzification(t2, GeometricMean())
    end

    @testset "Aritmetic mean" begin 
        t = Triangular(1, 50, 100)
        @test defuzzification(t, ArithmeticMean()) == (1 + 50 + 100)/3
    end 
end
