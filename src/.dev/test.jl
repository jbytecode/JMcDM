using Test
using DataFrames


include("playground.jl")

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

@testset "Make Decision Matrix" begin
    m = rand(5, 10)
    df = makeDecisionMatrix(m)

    @test isa(df, DataFrame)
    @test size(df) == (5, 10)
end

@testset "TOPSIS" begin
    tol = 0.00001
    df = DataFrame()
    df[:, :x] = Float64[9, 8, 7]
    df[:, :y] = Float64[7, 7, 8]
    df[:, :z] = Float64[6, 9, 6]
    df[:, :q] = Float64[7, 6, 6]
    w = Float64[4, 2, 6, 8]
    result = topsis(df, w)

    @test isa(result, TopsisResult)
    @test result.bestIndex == 2
    @test isapprox(result.scores, [0.3876870, 0.6503238, 0.0834767], atol=tol)
end

@testset "VIKOR" begin
    tol = 0.00001
    w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
    Amat = [
      100 92 10 2 80 70 95 80 ;
      80  70 8  4 100 80 80 90 ;
      90 85 5 0 75 95 70 70 ; 
      70 88 20 18 60 90 95 85
    ]
    dmat = makeDecisionMatrix(Amat)
    result = vikor(dmat, w)

    @test isa(result, VikorResult)
    @test result.bestIndex == 4
    
    @test isapprox(result.scores[1], 0.1975012087551764, atol=tol)
    @test isapprox(result.scores[2], 0.2194064473270817, atol=tol)
    @test isapprox(result.scores[3], 0.3507643203516215, atol=tol)
    @test isapprox(result.scores[4], -0.16727341435277993, atol=tol) 
end


@testset "ELECTRE" begin
    tol = 0.00001
    w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
    Amat = [
      100 92 10 2 80 70 95 80 ;
      80  70 8  4 100 80 80 90 ;
      90 85 5 0 75 95 70 70 ; 
      70 88 20 18 60 90 95 85
    ]
    dmat = makeDecisionMatrix(Amat)
    result = electre(dmat, w)

    @test isa(result, ElectreResult)
    @test isa(result.bestIndex, Tuple)
    @test result.bestIndex[1] == 4
    
    @test isapprox(result.C, [0.36936937,  0.01501502, -2.47347347,  2.08908909], atol=tol)
    @test isapprox(result.D, [0.1914244, -0.1903929,  2.8843076, -2.8853391], atol=tol)
end


@testset "MOORA" begin
    tol = 0.00001
    w =  [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
    Amat = [
      100 92 10 2 80 70 95 80 ;
      80  70 8  4 100 80 80 90 ;
      90 85 5 0 75 95 70 70 ; 
      70 88 20 18 60 90 95 85
    ]
    dmat = makeDecisionMatrix(Amat)
    result = moora(dmat, w)

    @test isa(result, MooraResult)
    @test isa(result.bestIndex, Int64)
    @test result.bestIndex == 4

    @test isapprox(result.scores, [0.33159387, 0.29014464, 0.37304311, 0.01926526], atol=tol)
end

