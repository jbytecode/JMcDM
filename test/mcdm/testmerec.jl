@testset "MEREC" begin
    tol = 0.0001
    decmat = hcat(
        [450.0, 10, 100, 220, 5],
        [8000, 9100, 8200, 9300, 8400],
        [54, 2, 31, 1, 23],
        [145, 160, 153, 162, 158],
    )

    fns = [maximum, maximum, minimum, minimum]

    result = merec(decmat, fns)
    @test result isa MERECResult
    @test isapprox(
        result.w,
        [
            0.5752216672093823,
            0.01409659116846726,
            0.40156136388773117,
            0.009120377734419302,
        ],
        atol = tol,
    )

    setting = MCDMSetting(decmat, zeros(4), fns)
    result2 = merec(setting)
    @test result2 isa MERECResult
    @test result2.w == result.w
end