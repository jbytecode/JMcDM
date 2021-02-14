using Test
using DataFrames


using JMcDM

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



@testset "Game" begin
    
    tol = 0.00001

    mat = [-2 6 3;
        3 -4 7;
        -1 2 4]
 
    dm = makeDecisionMatrix(mat)
    result = game(dm)

    @test isa(result, GameResult)

    @test result.value == 0.6666666666666661

    @test isapprox(result.row_player_probabilities, [0.4666667, 0.5333333, 0.0000000], atol=tol) 
        
end

@testset "Game - Rock & Paper & Scissors" begin

    tol = 0.00001

    mat = [0 -1 1;
      1 0 -1;
       -1 1 0]
 
    dm = makeDecisionMatrix(mat)
    result = game(dm)

    @test isa(result, GameResult)

    @test result.value == 0.0

    @test isapprox(result.row_player_probabilities, [0.333333, 0.333333, 0.33333], atol=tol) 
        
end


@testset "Data Envelopment" begin
    
    tol = 0.00001

    x1 = [96.0, 84, 90, 81, 102, 83, 108, 99, 95]
    x2 = [300.0, 282, 273, 270, 309, 285, 294, 288, 306]

    out = [166.0, 150, 140, 136, 171, 144, 172, 170, 165]
    inp = hcat(x1, x2)

    result::DataEnvelopResult = dataenvelop(inp, out)

    @test isa(result, DataEnvelopResult)


    @test result.orderedcases == [:Case8, :Case2, :Case7, :Case1, :Case9, :Case6, :Case5, :Case4, :Case3]

    @test isapprox(result.efficiencies, 
        [0.9879815986198964, 0.9999999999999999, 
        0.8959653733189055, 0.9421686746987951, 
        0.9659435120753173, 0.9715662650602411, 
        0.9911164465786314, 1.0, 0.9841048789857857], atol=tol)

   @test isapprox(result.references[:, :Case1],
        [0.0, 0.544106, 0.0, 0.0, 0.0, 
        0.0, 0.0, 0.496377, 0.0], atol=tol) 

   @test isapprox(result.references[:, :Case2],
        [0.0, 1, 0, 0, 0, 0, 0, 0, 0], atol=tol) 
     
    @test isapprox(result.references[:, :Case3],
        [0.0, 0.266193, 0, 0, 0, 0, 0, 0.588654, 0], atol=tol) 

    @test isapprox(result.references[:, :Case4],
        [0.0, 0.860241, 0, 0, 0, 0, 0, 0.0409639, 0], atol=tol) 
    
    @test isapprox(result.references[:, :Case5],
        [0.0, 0.314982, 0, 0, 0, 0, 0, 0.727957, 0], atol=tol) 

    @test isapprox(result.references[:, :Case6],
        [0.0, 0.96 , 0, 0, 0, 0, 0, 0, 0], atol=tol) 
    
    @test isapprox(result.references[:, :Case7],
        [0.0, 0 , 0, 0, 0, 0, 0, 1.01176, 0], atol=tol)  
        
    @test isapprox(result.references[:, :Case8],
        [0.0, 0 , 0, 0, 0, 0, 0, 1.0, 0], atol=tol) 
        
    @test isapprox(result.references[:, :Case9],
        [0.0, 0.774923 , 0, 0, 0, 0, 0, 0.286833, 0], atol=tol) 
        
end


@testset "Grey Relational Analysis" begin
    
    tol = 0.0001
    
    df = DataFrame(
        :K1 => [105000.0, 120000, 150000, 115000, 135000],
        :K2 => [105.0, 110, 120, 105, 115],
        :K3 => [10.0, 15, 12, 20, 15],
        :K4 => [4.0, 4, 3, 4, 5],
        :K5 => [300.0, 500, 550, 600, 400],
        :K6 => [10.0, 8, 12, 9, 9]
    )
    functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]



    w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

    result = grey(df, w, functionlist)

    @test isa(result, GreyResult)
    
    @test isapprox(result.scores, [0.525, 0.7007142857142857, 
    0.5464285714285715, 0.5762820512820512, 0.650952380952381], atol=tol)

    @test result.bestIndex == 2
end


@testset "SAW" begin
    
    @testset "Example 1: 4 criteria × 4 alternatives" begin
        tol = 0.0001
        df = DataFrame(
            :c1 => [25.0, 21, 19, 22],
            :c2 => [65.0, 78, 53, 25],
            :c3 => [7.0, 6, 5, 2],
            :c4 => [20.0, 24, 33, 31]
        )
        weights = [0.25, 0.25, 0.25, 0.25]
        fns = [maximum, maximum, minimum, maximum]
        result = saw(df, weights, fns)

        @test result isa SawResult

        @test isapprox(result.scores, [0.681277, 0.725151, 0.709871, 0.784976], atol=tol)
    end

    @testset "Example 2: 7 criteria × 5 alternatives " begin
        tol = 0.0001
        decmat = [4.0  7  3  2  2  2  2;
                  4.0  4  6  4  4  3  7;
                  7.0  6  4  2  5  5  3;
                  3.0  2  5  3  3  2  5;
                  4.0  2  2  5  5  3  6]

        df = makeDecisionMatrix(decmat)
        weights = [0.283, 0.162, 0.162, 0.07, 0.085, 0.162, 0.076]
        fns = convert(Array{Function,1}, [maximum for i in 1:7])
        result = saw(df, weights, fns)

        @test result isa SawResult
        @test isapprox(result.scores, [0.553228, 0.713485, 0.837428, 0.514657, 0.579342], atol=tol)
        @test result.bestIndex == 3
        @test result.ranking == [3, 2, 5, 1, 4]
    end
end

@testset "ARAS Additive Ratio Assessment" begin
    
    tol = 0.0001
    
    df = DataFrame(
        :K1 => [105000.0, 120000, 150000, 115000, 135000],
        :K2 => [105.0, 110, 120, 105, 115],
        :K3 => [10.0, 15, 12, 20, 15],
        :K4 => [4.0, 4, 3, 4, 5],
        :K5 => [300.0, 500, 550, 600, 400],
        :K6 => [10.0, 8, 12, 9, 9]
    )
    functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

    w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

    result = aras(df, w, functionlist)

    @test isa(result, ARASResult)
    
    @test isapprox(result.scores, [0.81424068, 0.89288620, 0.76415790, 0.84225462, 0.86540635], atol=tol)

    @test result.bestIndex == 2
end

@testset "WPM" begin
    tol = 0.0001
    decmat = [3	12.5	2	120	14	3;
                5	15	3	110	38	4;
                3	13	2	120	19	3;
                4	14	2	100	31	4;
                3	15	1.5	125	40	4]

    df = makeDecisionMatrix(decmat)

    weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

    fns = [maximum, minimum, minimum, maximum, minimum, maximum]
    
    result = wpm(df, weights, fns)

    @test result isa WPMResult

    @test isapprox(result.scores, [0.7975224331331, 0.7532541470585, 0.7647463553356, 0.7873956894791, 0.7674278741782], atol=tol)
    
end

@testset "WASPAS" begin
    tol = 0.0001
    decmat = [3	12.5	2	120	14	3;
                5	15	3	110	38	4;
                3	13	2	120	19	3;
                4	14	2	100	31	4;
                3	15	1.5	125	40	4]

    df = makeDecisionMatrix(decmat)

    weights = [0.221, 0.159, 0.175, 0.127, 0.117, 0.201]

    fns = [maximum, minimum, minimum, maximum, minimum, maximum]
    
    result = waspas(df, weights, fns)

    @test result isa WASPASResult

    @test isapprox(result.scores, [0.805021, 0.775060, 0.770181, 0.796424, 0.788239], atol=tol)
    
end

@testset "EDAS" begin
    tol = 0.0001
    decmat = [5000 5 5300 450;
                4500 5 5000 400;
                4500 4 4700 400;
                4000 4 4200 400;
                5000 4 7100 500;
                5000 5 5400 450;
                5500 5 6200 500;
                5000 4 5800 450]

    df = makeDecisionMatrix(decmat)

    weights = [0.25, 0.25, 0.25, 0.25];

    fns = [maximum, maximum, minimum, minimum];

    result = edas(df, weights, fns)

    @test result isa EDASResult

    @test isapprox(result.scores, [0.759594, 0.886016, 0.697472, 0.739658, 0.059083, 0.731833, 0.641691, 0.385194], atol=tol)
    
end

@testset "MARCOS" begin
    
    tol = 0.0001
    decmat = [8.675 8.433 8.000 7.800 8.025 8.043;
    8.825 8.600 7.420 7.463 7.825 8.229;
    8.325 7.600 8.040 7.700 7.925 7.600;
    8.525 8.667 7.180 7.375 7.750 8.071]

    df = makeDecisionMatrix(decmat)

    weights = [0.19019, 0.15915, 0.19819, 0.19019, 0.15115, 0.11111];

    fns = [maximum, maximum, maximum, maximum, maximum, maximum];

    Fns = convert(Array{Function, 1} , fns)

    result = marcos(df, weights, Fns)

    @test result isa MARCOSResult

    @test isapprox(result.scores, [0.684865943528, 0.672767106696, 0.662596906139, 0.661103207660], atol=tol)
    
end