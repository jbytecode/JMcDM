@testset "Fuzzy Edas" verbose = true begin

    epsilon = 0.1

    decmat = Triangular[
        Triangular(7.67, 9.00, 9.67) Triangular(5.67, 7.67, 9.33) Triangular(5.33, 6.67, 7.67) Triangular(0.67, 2.33, 4.33) Triangular(1.33, 2.67, 4.33) Triangular(2.00, 3.67, 5.67) Triangular(1.33, 3.00, 5.00) Triangular(8.33, 9.67, 10.0) Triangular(3.67, 5.67, 7.33) Triangular(4.33, 6.33, 8.00) Triangular(5.67, 7.33, 8.33) Triangular(5.00, 7.00, 8.33) Triangular(1.33, 3.00, 5.00) Triangular(4.67, 6.33, 7.67);
        Triangular(3.00, 5.00, 7.00) Triangular(0.33, 1.67, 3.67) Triangular(4.33, 6.33, 8.33) Triangular(4.33, 6.33, 8.33) Triangular(0.33, 1.67, 3.67) Triangular(3.00, 5.00, 7.00) Triangular(4.33, 6.33, 8.33) Triangular(6.33, 8.00, 9.33) Triangular(0.67, 2.33, 4.33) Triangular(4.67, 6.00, 7.33) Triangular(5.67, 7.33, 8.33) Triangular(5.00, 6.67, 8.00) Triangular(4.00, 5.33, 6.67) Triangular(4.33, 6.00, 7.33);
        Triangular(6.33, 8.33, 9.67) Triangular(3.00, 5.00, 7.00) Triangular(5.00, 7.00, 8.67) Triangular(2.33, 4.33, 6.33) Triangular(1.33, 2.67, 4.33) Triangular(2.00, 3.67, 5.67) Triangular(3.33, 5.00, 6.67) Triangular(4.33, 6.33, 8.33) Triangular(2.33, 4.33, 6.33) Triangular(5.00, 7.00, 8.33) Triangular(5.67, 7.33, 8.67) Triangular(5.67, 7.33, 8.33) Triangular(1.33, 3.00, 5.00) Triangular(3.67, 5.67, 7.33);
        Triangular(8.33, 9.67, 10.0) Triangular(5.67, 7.33, 8.67) Triangular(6.33, 8.33, 9.67) Triangular(1.33, 3.00, 5.00) Triangular(0.67, 2.00, 3.67) Triangular(5.00, 7.00, 8.67) Triangular(5.00, 6.67, 8.00) Triangular(5.67, 7.67, 9.33) Triangular(4.67, 5.00, 7.33) Triangular(3.00, 5.00, 7.00) Triangular(3.67, 5.67, 7.33) Triangular(3.67, 5.67, 7.33) Triangular(1.33, 3.00, 5.00) Triangular(4.00, 5.67, 7.33);
        Triangular(7.67, 9.33, 10.0) Triangular(6.33, 8.33, 9.67) Triangular(5.67, 7.67, 9.00) Triangular(0.67, 2.00, 3.67) Triangular(1.67, 3.00, 5.00) Triangular(3.33, 5.00, 7.00) Triangular(3.33, 5.00, 7.00) Triangular(4.33, 6.33, 8.33) Triangular(6.33, 8.00, 9.33) Triangular(5.00, 7.00, 8.33) Triangular(4.33, 6.33, 8.00) Triangular(5.00, 7.00, 8.33) Triangular(0.67, 2.33, 4.33) Triangular(4.00, 5.67, 7.33)
    ]

    fns = [
        maximum,
        maximum,
        maximum,
        minimum,
        minimum,
        minimum,
        minimum,
        minimum,
        minimum,
        maximum,
        maximum,
        maximum,
        maximum,
        maximum
    ]

    weights = Triangular[
        Triangular(0.700, 0.900, 1.000),
        Triangular(0.367, 0.567, 0.767),
        Triangular(0.500, 0.700, 0.867),
        Triangular(0.567, 0.767, 0.933),
        Triangular(0.767, 0.933, 1.000),
        Triangular(0.633, 0.833, 0.967),
        Triangular(0.633, 0.833, 0.967),
        Triangular(0.567, 0.733, 0.867),
        Triangular(0.367, 0.567, 0.767),
        Triangular(0.567, 0.767, 0.933),
        Triangular(0.567, 0.733, 0.867),
        Triangular(0.767, 0.933, 1.000),
        Triangular(0.767, 0.933, 1.000),
        Triangular(0.633, 0.800, 0.933)
    ]

    defuzmatrix = Float64[
        8.78000 7.55667 6.55667 2.44333 2.77667 3.78000 3.11000 9.33333 5.55667 6.22000 7.11000 6.77667 3.11000 6.22333;
        5.00000 1.89000 6.33000 6.33000 1.89000 5.00000 6.33000 7.88667 2.44333 6.00000 7.11000 6.55667 5.33333 5.88667;
        8.11000 5.00000 6.89000 4.33000 2.77667 3.78000 5.00000 6.33000 4.33000 6.77667 7.22333 7.11000 3.11000 5.55667;
        9.33333 7.22333 8.11000 3.11000 2.11333 6.89000 6.55667 7.55667 5.66667 5.00000 5.55667 5.55667 3.11000 5.66667;
        9.00000 8.11000 7.44667 2.11333 3.22333 5.11000 5.11000 6.33000 7.88667 6.77667 6.22000 6.77667 2.44333 5.66667
    ]

    pda_col1 = Triangular[
        Triangular(-0.199, 0.091, 0.382),
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.365, 0.008, 0.382),
        Triangular(-0.117, 0.175, 0.423),
        Triangular(-0.199, 0.132, 0.423)
    ]

    pda_col4 = Triangular[
        Triangular(-0.672, 0.346, 1.326),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.855, 0.163, 1.146),
        Triangular(-0.492, 0.436, 1.326)
    ]


    nda_col1 = Triangular[
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.050, 0.406, 0.779),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000)
    ]

    nda_col4 = Triangular[
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.328, 0.745, 1.764),
        Triangular(-0.874, 0.200, 1.218),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000)
    ]


    w_pda_col1 = Triangular[
        Triangular(-0.139, 0.082, 0.382),
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.256, 0.007, 0.382),
        Triangular(-0.082, 0.157, 0.423),
        Triangular(-0.139, 0.119, 0.423)
    ]

    w_pda_col4 = Triangular[
        Triangular(-0.381, 0.265, 1.238),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.485, 0.125, 1.070),
        Triangular(-0.279, 0.334, 1.238)
    ]

    w_nda_col1 = Triangular[
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.035, 0.365, 0.779),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000)
    ]

    w_nda_col4 = Triangular[
        Triangular(0.000, 0.000, 0.000),
        Triangular(-0.186, 0.572, 1.645),
        Triangular(-0.495, 0.153, 1.136),
        Triangular(0.000, 0.000, 0.000),
        Triangular(0.000, 0.000, 0.000)
    ]

    sp = Triangular[
        Triangular(-2.351, 1.229, 6.352),
        Triangular(-2.010, 1.180, 5.311),
        Triangular(-2.118, 0.682, 4.839),
        Triangular(-1.636, 0.667, 3.981),
        Triangular(-1.949, 1.007, 5.166)
    ]

    sn = Triangular[
        Triangular(-2.046, 0.510, 3.867),
        Triangular(-1.691, 1.710, 6.461),
        Triangular(-2.847, 0.484, 5.195),
        Triangular(-2.700, 1.147, 6.572),
        Triangular(-2.436, 0.914, 5.539)
    ]

    spdefuz = Float64[
        1.74,
        1.49,
        1.13,
        1.00,
        1.41
    ]


    sndefuz = Float64[
        0.78,
        2.16,
        0.94,
        1.67,
        1.34
    ]

    nsp = Triangular[
        Triangular(-1.348, 0.705, 3.644),
        Triangular(-1.153, 0.677, 3.046),
        Triangular(-1.215, 0.391, 2.776),
        Triangular(-0.939, 0.383, 2.284),
        Triangular(-1.118, 0.578, 2.963)
    ]

    nsn = Triangular[
        Triangular(-0.790, 0.764, 1.947),
        Triangular(-1.991, 0.208, 1.783),
        Triangular(-1.405, 0.776, 2.318),
        Triangular(-2.043, 0.469, 2.250),
        Triangular(-1.564, 0.577, 2.128)
    ]


    as = Triangular[
        Triangular(-1.069, 0.734, 2.795),
        Triangular(-1.572, 0.442, 2.415),
        Triangular(-1.310, 0.584, 2.547),
        Triangular(-1.491, 0.426, 2.267),
        Triangular(-1.341, 0.577, 2.546)
    ]

    scores = Float64[
        0.82,
        0.43,
        0.61,
        0.40,
        0.59
    ]

    ranks = Int64[
        1,
        4,
        2,
        5,
        3
    ]

    avgdefuz = Float64[8.04, 5.96, 7.07, 3.67, 2.56, 4.91, 5.22, 7.49, 5.24, 6.15, 6.64, 6.58, 3.42, 5.80]
    n, p = size(decmat)

    @test n == 5
    @test p == 14


    result = fuzzyedas(decmat, weights, fns)


    @test isapprox(result.defuzmatrix, defuzmatrix, atol=epsilon)
    @test isapprox(result.avgdefuz, avgdefuz, atol=epsilon)

    for i in 1:n
        @test isapprox(result.pda[i, 1], pda_col1[i], atol=epsilon)
    end
    for i in 1:n
        @test isapprox(result.pda[i, 4], pda_col4[i], atol=epsilon)
    end
    for i in 1:n
        @test isapprox(result.nda[i, 1], nda_col1[i], atol=epsilon)
    end
    for i in 1:n
        @test isapprox(result.nda[i, 4], nda_col4[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.wpda[i, 1], w_pda_col1[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.wpda[i, 4], w_pda_col4[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.wnda[i, 1], w_nda_col1[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.wnda[i, 4], w_nda_col4[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.sp[i], sp[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.sn[i], sn[i], atol=epsilon)
    end


    @test isapprox(result.sp_defuz, spdefuz, atol=epsilon)
    @test isapprox(result.sn_defuz, sndefuz, atol=epsilon)

    for i in 1:n
        @test isapprox(result.nsp[i], nsp[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.nsn[i], nsn[i], atol=epsilon)
    end

    for i in 1:n
        @test isapprox(result.as[i], as[i], atol=epsilon)
    end

    @test isapprox(result.scores, scores, atol=epsilon)

    @test result.ranks == ranks

end