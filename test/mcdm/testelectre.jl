@testset "ELECTRE" begin
    tol = 0.00001
    w = [0.110, 0.035, 0.379, 0.384, 0.002, 0.002, 0.010, 0.077]
    Amat = [
        100 92 10 2 80 70 95 80.0
        80 70 8 4 100 80 80 90
        90 85 5 0 75 95 70 70
        70 88 20 18 60 90 95 85
    ]
    fns = [maximum for i ∈ 1:8]
    result = electre(Amat, w, fns)

    @test isa(result, ElectreResult)
    @test isa(result.bestIndex, Tuple)
    @test result.bestIndex[1] == 4

    @test isapprox(
        result.C,
        [0.36936937, 0.01501502, -2.47347347, 2.08908909],
        atol = tol,
    )
    @test isapprox(result.D, [0.1914244, -0.1903929, 2.8843076, -2.8853391], atol = tol)

    setting = MCDMSetting(Amat, w, fns)
    result2 = electre(setting)
    @test result isa ElectreResult
    @test result.bestIndex == result2.bestIndex

    result3 = mcdm(setting, ElectreMethod())
    @test result3 isa ElectreResult
    @test result3.bestIndex == result.bestIndex
end

@testset "Electre (failed in previous release <= v0.2.5" begin
    decmat = hcat(
        [1.0, 2.0, 3.0, 2.0],
        [1.0, 2.0, 1.0, 1.0],
        [1.0, 3.0, 2.0, 2.0],
        [4.0, 2, 1, 4],
    )
    fns = [maximum, maximum, maximum, maximum]
    ws = [0.25, 0.25, 0.25, 0.25]
    e = electre(decmat, ws, fns)

    @test e isa ElectreResult
    @test e.bestIndex == (2, 1)
end