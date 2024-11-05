@testset "CRITIC" begin
    tol = 0.0001
    decmat = [
        12.9918 0.7264 -1.1009 1.598139592
        4.1201 5.8824 3.4483 1.021563567
        4.1039 0.0000 -0.5076 0.984469444
    ]

    fns = [maximum, maximum, minimum, maximum]

    result = critic(decmat, fns)
    @test result isa CRITICResult
    @test isapprox(
        result.w,
        [0.16883925, 0.418444976, 0.249124763, 0.163591012],
        atol = tol,
    )
    @test isapprox(result.scores, [1.0380664664796384, 2.572718248762683, 1.5316754449023655, 1.005800182228836], atol = tol)
    @test isapprox(
        result.correlationmatrix,
        [
            0.0 1.3972590509606788 0.4009928509605405 0.0013698033055495884;
            1.3972590509606788 0.0 1.9728086997410341 1.348697428776955;
            0.4009928509605405 1.9728086997410341 0.0 0.44371094387732823;
            0.0013698033055495884 1.348697428776955 0.44371094387732823 0.0
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, zeros(4), fns)
    result2 = critic(setting)
    @test result2 isa CRITICResult
    @test result2.w == result.w
end