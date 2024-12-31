@testset "RAM tests" verbose = true begin

    #=
    This example is taken from the original paper of the RAM method:
    
    Sotoudeh-Anvari, Alireza. "Root Assessment Method (RAM): A novel multi-criteria 
    decision making method and its applications in sustainability challenges." 
    Journal of Cleaner Production 423 (2023): 138695.
    =#
    @testset "Original paper test" begin
        
        eps = 0.01

        decmat = [
            0.068 0.066 0.150 0.098 0.156 0.114 0.098;
            0.078 0.076 0.108 0.136 0.082 0.171 0.105;
            0.157 0.114 0.128 0.083 0.108 0.113 0.131;
            0.106 0.139 0.058 0.074 0.132 0.084 0.120;
            0.103 0.187 0.125 0.176 0.074 0.064 0.057;
            0.105 0.083 0.150 0.051 0.134 0.094 0.113;
            0.137 0.127 0.056 0.133 0.122 0.119 0.114;
            0.100 0.082 0.086 0.060 0.062 0.109 0.093;
            0.053 0.052 0.043 0.100 0.050 0.078 0.063;
            0.094 0.074 0.097 0.087 0.080 0.054 0.106
        ]

        w = [0.132, 0.135, 0.138, 0.162, 0.09, 0.223, 0.120]

        dirs = [maximum, minimum, minimum, maximum, maximum, maximum, maximum]

        normalized = [
            0.067879 0.066 0.149783 0.098148 0.156 0.113991 0.098;
            0.077879 0.076 0.107826 0.136235 0.082 0.170987 0.105;
            0.156818 0.114 0.127826 0.083148 0.108 0.11296 0.131;
            0.105833 0.138963 0.057899 0.074136 0.132 0.083991 0.12;
            0.102879 0.186963 0.124855 0.176296 0.074 0.063991 0.057;
            0.104848 0.082963 0.149783 0.051049 0.134 0.093139 0.113;
            0.136818 0.126963 0.055942 0.13321 0.122 0.117937 0.114;
            0.099848 0.082 0.08587 0.060062 0.062 0.108969 0.093;
            0.052879 0.052 0.042899 0.100185 0.05 0.077982 0.063;
            0.093864 0.074 0.096884 0.08716 0.08 0.053812 0.106]

        wnormalized = [
            0.00896 0.00891 0.02067 0.0159 0.01404 0.02542 0.01176;
            0.01028 0.01026 0.01488 0.02207 0.00738 0.03813 0.0126;
            0.0207 0.01539 0.01764 0.01347 0.00972 0.02519 0.01572;
            0.01397 0.01876 0.00799 0.01201 0.01188 0.01873 0.0144;
            0.01358 0.02524 0.01723 0.02856 0.00666 0.01427 0.00684;
            0.01384 0.0112 0.02067 0.00827 0.01206 0.02077 0.01356;
            0.01806 0.01714 0.00772 0.02158 0.01098 0.0263 0.01368;
            0.01318 0.01107 0.01185 0.00973 0.00558 0.0243 0.01116;
            0.00698 0.00702 0.00592 0.01623 0.0045 0.01739 0.00756;
            0.01239 0.00999 0.01337 0.01412 0.0072 0.012 0.01272]

        splusi = [
            0.07609,
            0.090475,
            0.08481,
            0.071,
            0.06992,
            0.0687,
            0.09085,
            0.06397,
            0.05267,
            0.05848]

        sminusi = [
            0.029589,
            0.025149,
            0.03303,
            0.02676,
            0.04247,
            0.03188,
            0.02486,
            0.02292,
            0.01294,
            0.02336]

        sqrvals = [
            1.433215,
            1.439243,
            1.435296,
            1.432197,
            1.42788,
            1.43012,
            1.439444,
            1.430766,
            1.429406,
            1.428773]

        norRI = [
            0.4613,
            0.9826,
            0.6413,
            0.3733,
            0,
            0.1937,
            1,
            0.2495,
            0.1319,
            0.07724]

        ranks = [
            4,
            2,
            3,
            5,
            10,
            7,
            1,
            6,
            8,
            9]

        bestindex = 7

        result = ram(decmat, w, dirs)
        
        @test result isa RAMResult

        @test isapprox(result.decisionMatrix, decmat; atol = eps)

        @test isapprox(result.normalizedMatrix, normalized; atol = eps)

        @test isapprox(result.weightedNormalizedMatrix, wnormalized; atol = eps)

        @test isapprox(result.splusi, splusi; atol = eps)

        @test isapprox(result.sminusi, sminusi; atol = eps)

        @test isapprox(result.scores, sqrvals; atol = eps)

        @test isapprox(result.norRI, norRI; atol = eps)

        @test isapprox(result.ranks, ranks; atol = eps)

        @test result.bestindex == bestindex

    end
end