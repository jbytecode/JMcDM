using Test
using DataFrames


using JMCDM

@testset "Euclidean distance" begin
    @test euclidean([0.0, 1.0, 2.0], [0.0, 1.0, 2.0]) == 0.0
    @test euclidean([0.0, 0.0, 0.0]) == 0.0
    @test euclidean([0.0, 0.0, 1.0]) == 1.0
    @test euclidean([0.0, 0.0, 1.0], [0.0, 0.0, 2.0]) == 1.0
end

@testset "Normalization" begin
    tol = 0.00001
    nz = normalize([1.0, 2.0, 3.0, -1.0, 0.0])
    @test isapprox(nz[1], 0.2581989, atol=tol)
    @test isapprox(nz[2], 0.5163978, atol=tol)
    @test isapprox(nz[3], 0.7745967, atol=tol)
    @test isapprox(nz[4], -0.2581989, atol=tol)
    @test isapprox(nz[5], 0.0000000, atol=tol)
end

@testset "Column min and max vectors" begin
    df = DataFrame()
    df[:,:x] = [0.0, 1.0, 10.0]
    df[:,:y] = [0.0, -1.0, -10.0]
    @test colmins(df) == [0.0, -10.0]
    @test colmaxs(df) == [10.0, 0.0]
end

@testset "Unitize vector" begin
    x = [1.0, 2.0, 3.0, 4.0, 5.0]
    result = x |> unitize |> sum
    @test result == 1.0
end

@testset "Product weights with DataFrame" begin
    df = DataFrame()
    df[:, :x] = [1.0, 2.0, 4.0, 8.0]
    df[:, :y] = [10.0, 20.0, 30.0, 40.0]
    w = [0.60, 0.40]
    result = w * df 

    @test result[:, :x] == [0.6, 1.2, 2.4, 4.8]
    @test result[:, :y] == [4.0, 8.0, 12.0, 16.0]
end

@testset "TOPSIS" begin
    tol = 0.00001
    df = DataFrame()
    df[:, :x] = Float64[9, 8, 7]
    df[:, :y] = Float64[7, 7, 8]
    df[:, :z] = Float64[6, 9, 6]
    df[:, :q] = Float64[7, 6, 6]
    w = Float64[4, 2, 6, 8]
    t::TopsisResult = topsis(df, w)
    @test t.bestIndex == 2
    @test isapprox(t.scores, [0.3876870, 0.6503238, 0.0834767], atol=tol)
end

