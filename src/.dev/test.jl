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


@testset "DEMATEL" begin
    tol = 0.00001
    K = [
        0 3 0 2 0 0 0 0 3 0;
        3 0 0 0 0 0 0 0 0 2;
        4 1 0 2 1 3 1 2 3 2;
        4 1 4 0 1 2 0 1 0 0;
        3 2 3 1 0 3 0 2 0 0;
        4 1 4 4 0 0 0 1 1 3;
        3 0 0 0 0 2 0 0 0 0;
        3 0 4 3 2 3 1 0 0 0;
        4 3 2 0 0 1 0 0 0 2;
        2 1 0 0 0 0 0 0 3 0
    ]

    dmat = makeDecisionMatrix(K)

    result = dematel(dmat)

    @test isapprox(result.threshold, 0.062945, atol=tol) 

    @test isapprox(result.c, [0.3991458, 0.2261648, 1.0204318, 0.7538625,
                           0.8096760, 0.9780926, 0.2717874,
                           0.9455390, 0.5960514, 0.2937537], atol=tol)
    
    @test isapprox(result.r, [1.5527024, 0.7251791, 0.8551461, 0.6895615,
                           0.2059141, 0.6790404, 0.1057168,
                           0.3163574, 0.6484014, 0.5164858], atol=tol)

    @test isapprox(result.influenceMatrix, 
            [ 0.0  1.0  0.0  1.0  0.0  0.0  0.0  0.0  1.0  0.0;
            1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0;
            1.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0  1.0  1.0;
            1.0  1.0  1.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0;
            1.0  1.0  1.0  1.0  0.0  1.0  0.0  1.0  0.0  0.0;
            1.0  1.0  1.0  1.0  0.0  0.0  0.0  0.0  1.0  1.0;
            1.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0;
            1.0  0.0  1.0  1.0  1.0  1.0  0.0  0.0  0.0  0.0;
            1.0  1.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0;
            1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0], atol=tol)  
            
    @test isapprox(result.weights,
        [0.1686568559124561,
        0.07991375718719543,
        0.14006200243438863,
        0.10748052790517183,
        0.08789022388276985,
        0.12526272598854982,
        0.03067915023486491,
        0.10489168834828348,
        0.092654758940811,
        0.06250830916550884
    ], atol=tol)
   
end


@testset "AHP - Consistency" begin

    tol = 0.00001

    K = [
        1 7 (1 / 5) (1 / 8) (1 / 2) (1 / 3) (1 / 5) 1;
        (1 / 7) 1 (1 / 8) (1 / 9) (1 / 4) (1 / 5) (1 / 9) (1 / 8);
        5 8 1 (1 / 3) 4 2 1 1;
        8 9 3 1 7 5 3 3;
        2 4 (1 / 4) (1 / 7) 1 (1 / 2) (1 / 5) (1 / 5);
        3 5 (1 / 2) (1 / 5) 2 1 (1 / 3) (1 / 3);
        5 9 1 (1 / 3) 5 3 1 1;
        1 8 1 (1 / 3) 5 3 1 1
    ]

    dmat = makeDecisionMatrix(K)
    result::AHPConsistencyResult = ahp_consistency(dmat)

    @test isa(result, AHPConsistencyResult)
    
    @test result.isConsistent 

    @test isapprox(result.CR, 0.07359957154133831, atol=tol) 

    @test isapprox(result.CI, 0.10377539587328702, atol=tol)

    @test isapprox(result.lambda_max, 8.72642777111301, atol=tol)

    @test isapprox(result.pc, [
        8.40982182534543
        8.227923797501001
        8.95201017080425
        8.848075127995905
        8.860427038870013
        8.941497805932498
        8.946071053879708
        8.62559534857526
    ], atol=tol)
end


@testset "AHP" begin
    
    tol = 0.00001

    K = [
    1 7 1 / 5 1 / 8 1 / 2 1 / 3 1 / 5 1;
    1 / 7 1 1 / 8 1 / 9 1 / 4 1 / 5 1 / 9 1 / 8;
    5 8 1 1 / 3 4 2 1 1;
    8 9 3 1 7 5 3 3;
    2 4 1 / 4 1 / 7 1 1 / 2 1 / 5 1 / 5;
    3 5 1 / 2 1 / 5 2 1 1 / 3 1 / 3;
    5 9 1 1 / 3 5 3 1 1;
    1 8 1 1 / 3 5 3 1 1
]

    A1 = [1 3 1 / 5 2;
                  1 / 3 1 1 / 7 1 / 3;
                  5 7 1 4;
                  1 / 2 3 1 / 4 1]
    A2 = [1 1 / 2 4 5;
                  2 1 6 7;
                  1 / 4 1 / 6 1 3;
                  1 / 5 1 / 7 1 / 3 1]
    A3 = [1 1 / 2 1 / 6 3;
                  2 1 1 / 4 5;
                  6 4 1 9;
                  1 / 3 1 / 5 1 / 9 1]
    A4 = [1 7 1 / 4 2;
                  1 / 7 1 1 / 9 1 / 5;
                  4 9 1 5;
                  1 / 2 5 1 / 5 1]
    A5 = [1 6 2 3;
                  1 / 6 1 1 / 4 1 / 3;
                  1 / 2 4 1 2;
                  1 / 3 3 1 / 2 1]
    A6 = [1 1 / 4 1 / 2 1 / 7;
                  4 1 2 1 / 3;
                  2 1 / 2 1 1 / 5;
                  7 3 5 1]
    A7 = [1 3 7 1;
                  1 / 3 1 4 1 / 3;
                  1 / 7 1 / 4 1 1 / 7;
                  1 3 7 1]
    A8 = [1 2 5 8;
                  1 / 2 1 3 6;
                  1 / 5 1 / 3 1 3;
                  1 / 8 1 / 6 1 / 3 1];

    km = makeDecisionMatrix(K)
    as = map(makeDecisionMatrix, [A1, A2, A3, A4, A5, A6, A7, A8])                  

    result = ahp(as, km) 

    @test isa(result, AHPResult)

    @test result.bestIndex == 3

    @test isapprox(result.scores, [0.2801050, 0.1482273, 0.3813036, 0.1903641], atol=tol) 
end


@testset "NDS" begin
    cases = [
        1.0 2.0 3.0;
        2.0 1.0 3.0;
        1.0 3.0 2.0;
        4.0 5.0 6.0
    ]

    nd = makeDecisionMatrix(cases)

    result = nds(nd)

    @test isa(result, NDSResult)

    @test result.bestIndex == 4

    @test result.ranks == [0, 0, 0, 3]

end


@testset "Laplace" begin
    
    tol = 0.00001

    mat = [
        3000 2750 2500 2250;
        1500 4750 8000 7750;
        2000 5250 8500 11750
    ]

    dm = makeDecisionMatrix(mat)

    result = laplace(dm)

    @test isa(result, LaplaceResult)

    @test isapprox(result.expected_values, [2625.0, 5500, 6875], atol=tol)

    @test result.bestIndex == 3
end


@testset "Maximin" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = maximin(dm)

    @test isa(result, MaximinResult)

    @test isapprox(result.rowmins, [18, 18, 24, 20], atol=tol) 

    @test result.bestIndex == 3
end


@testset "Maximax" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = maximax(dm)

    @test isa(result, MaximaxResult)

    @test isapprox(result.rowmaxs, [26, 34, 34, 30], atol=tol) 
     
    @test result.bestIndex in [2, 3]
end


@testset "Minimax" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = minimax(dm)

    @test isa(result, MinimaxResult)

    @test isapprox(result.rowmaxs, [26, 34, 34, 30], atol=tol) 
     
    @test result.bestIndex == 1
end


@testset "Minimin" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = minimin(dm)

    @test isa(result, MiniminResult)

    @test isapprox(result.rowmins, [18, 18,24,20], atol=tol) 
     
    @test result.bestIndex in [1, 2]
end



@testset "Savage" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = savage(dm)

    @test isa(result, SavageResult)
     
    @test result.bestIndex == 4

end





@testset "Hurwicz" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    dm = makeDecisionMatrix(mat)

    result = hurwicz(dm)

    @test isa(result, HurwiczResult)
     
    @test result.bestIndex == 3

end



@testset "Maximum likelihood for single criterion" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    weights = [0.2, 0.5, 0.2, 0.1]

    dm = makeDecisionMatrix(mat)

    result = mle(dm, weights)

    @test isa(result, MLEResult)
     
    @test result.bestIndex == 2
    
    @test isapprox(result.scores, [24, 29.2, 27, 27], atol=tol) 
end



@testset "Expected Regret" begin
    
    tol = 0.00001

    mat = [
        26 26 18 22;
        22 34 30 18;
        28 24 34 26;
        22 30 28 20
    ]

    weights = [0.2, 0.5, 0.2, 0.1]

    dm = makeDecisionMatrix(mat)

    result = expectedregret(dm, weights)

    @test isa(result, ExpectedRegretResult)
     
    @test result.bestIndex == 2
    
    @test isapprox(result.scores, [8, 2.8, 5, 5], atol=tol) 
end



