@testset "SD" begin

    @testset "SD with example" begin
        tol = 0.01
        mat = [
            391152 251165 2063102 912 18784 0.009 0.049 0.196
            181681 118972 1310114 525 12087 0.009 0.042 0.157
            156478 105801 993245 708 12279 0.01 0.041 0.177
            57145 34707 339417 210 3733 0.013 0.055 0.268
            34947 17568 340159 77 2015 0.014 0.043 0.204
            32667 19308 201372 48 1091 0.008 0.029 0.217
            28945 18033 117762 48 886 0.007 0.021 0.178
            18893 13816 139431 35 943 0.01 0.035 0.213
            18191 9088 47664 43 731 0.01 0.021 0.186
            12852 4185 64770 3 376 0.011 0.075 0.285
            10878 7107 11200 1 78 0.003 0.033 0.198
            4958 1730 4656 7 274 0.017 0.053 0.215
            3901 2318 15598 17 357 0.023 0.001 0.155
            2742 1042 52632 1 106 0.022 0.1 0.384
            1734 771 1894 1 33 0.011 0.125 0.709
            1677 568 1941 1 39 0.011 0.129 0.633
        ]

        fns = [maximum, maximum, maximum, minimum, minimum, minimum, maximum, maximum]

        result = sd(mat, fns)

        @test result isa SDResult
        @test isapprox(
            result.weights,
            [0.116, 0.117, 0.125, 0.137, 0.133, 0.116, 0.125, 0.131],
            atol = tol,
        )

        result1 = sd(mat, fns)
        @test result1 isa SDResult
        @test isapprox(
            result1.weights,
            [0.116, 0.117, 0.125, 0.137, 0.133, 0.116, 0.125, 0.131],
            atol = tol,
        )
    end


    @testset "SD without normalization" begin
        eps = 0.001
        decmat = hcat(
            [105000.0, 120000, 150000, 115000, 135000],
            [105.0, 110, 120, 105, 115],
            [10.0, 15, 12, 20, 15],
            [4.0, 4, 3, 4, 5],
            [300.0, 500, 550, 600, 400],
            [10.0, 8, 12, 9, 9],
        )
        functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

        sdresult = sd(decmat, functionlist, normalization = Normalizations.nullnormalization)
        w = sdresult.weights

        expected = [0.9925358892853197, 0.00036602915026898945, 0.0002123191795668205, 3.9701435571412785e-5, 0.006760910856275223, 8.515009299808652e-5]

        @test isapprox(w, expected, atol = eps)
    end
end
