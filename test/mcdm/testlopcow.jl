@testset "LOPCOW" begin
    tol = 0.0001
    decmat = [
        21.8 14.1 10.7 1.6 1.8 770.0 12750.0 18.0 5100.0 1.5 9.1 1.054 4.196 29.407 7.03 15.08 9.705;
        16.4 8.5 13.9 1.2 1.3 524.0 12087.0 5.7 2941.0 2.208 15.2 1.123 3.86 5.228 14.724 32.103 19.0;
        14.5 7.0 2.3 0.2 0.2 238.0 3265.0 1.9 320.0 2.32 16.202 1.008 3.095 5.549 17.34 65.129 32.056;
        18.2 10.3 11.4 1.2 1.1 835.0 16037.0 21.3 4332.0 0.875 9.484 0.856 2.191 23.75 13.1 58.157 27.46;
        18.5 8.1 11.1 1.0 1.1 504.0 9464.0 1.4 1743.0 2.95 0.7 0.479 2.44 8.77 13.48 33.45 17.68;
        18.7 11.4 10.8 1.3 1.5 1227.0 24053.0 20.0 6521.0 0.733 1.6 0.857 2.377 4.985 11.743 26.732 24.485;
        18.5 12.6 10.8 1.4 1.8 912.0 18800.0 18.2 5300.0 1.29 8.27 0.558 0.635 5.22 13.829 31.914 7.515;
        16.4 6.7 12.6 0.9 0.9 951.0 16767.0 22.0 3917.0 2.46 3.9 0.724 0.568 4.491 14.357 28.869 7.313;
        15.2 6.3 6.9 0.5 0.5 1013.0 20170.0 10.97 4060.0 1.67 1.7 0.704 2.96 3.24 10.029 60.981 23.541
    ]

    fns = [maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, maximum, minimum, minimum, minimum, minimum, minimum, minimum, minimum]

    result = lopcow(decmat, fns)
    @test result isa LOPCOWResult
    @test isapprox(
        result.w,
        [
            0.0494739618585499,
            0.0366230783749353,
            0.0845662443200203,
            0.0705594164719862,
            0.0637406420860843,
            0.0660734602415126,
            0.0699299682542297,
            0.0504004077191502,
            0.0689844249442893,
            0.0491618867560788,
            0.0555597725236513,
            0.0487457716462668,
            0.0482437589634006,
            0.0762536089544412,
            0.0550717149127653,
            0.0532072757707825,
            0.0534046062018556,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, zeros(17), fns)
    result2 = lopcow(setting)
    @test result2 isa LOPCOWResult
    @test result2.w == result.w
end