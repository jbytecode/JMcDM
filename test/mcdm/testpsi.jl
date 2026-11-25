@testset "PSI" begin
    tol = 0.0001

    decmat = hcat(
        Float64[9, 8, 7],
        Float64[7, 7, 8],
        Float64[6, 9, 6],
        Float64[7, 6, 6])

    w = Float64[4, 2, 6, 8]

    fns = [maximum, maximum, maximum, maximum]

    result = psi(decmat, fns)

    @test result isa PSIResult
    @test result.bestIndex == 2
    @test isapprox(
        [0.8884920812205419, 0.9038022662539607, 0.8281521210464404],
        result.scores,
        atol = tol,
    )

    setting = MCDMSetting(decmat, w, fns)
    result2 = mcdm(setting, PSIMethod())
    @test result2.bestIndex == result.bestIndex
    @test result2.scores == result.scores
    @test result2 isa PSIResult
end

@testset "PSI published examples: Petkovic et al. (2017), Tables 5 and 8" begin
    # Facta Universitatis Ser. Mech. Eng. 15(1):97-106, doi:10.22190/FUME151120001P
    decmat1 = [
        0.061 219.74 5.8
        0.093 3523.72 6.3
        0.064 2693.21 6.8
        0.028 761.46 5.8
        0.034 1593.48 5.8
        0.013 2849.15 6.2
    ]
    result1 = psi(decmat1, [minimum, minimum, minimum])
    @test all(isapprox.(result1.scores, [0.7851, 0.5492, 0.5333, 0.7226, 0.6724, 0.7949], atol = 0.00006))
    @test result1.bestIndex == 6

    decmat2 = [
        0.035 34.5 847 1.76 0.335 0.5 0.59 0.59
        0.027 36.8 834 1.68 0.335 0.665 0.665 0.665
        0.037 38.6 808 2.4 0.59 0.59 0.41 0.5
        0.028 32.6 821 1.59 0.5 0.59 0.59 0.41
    ]
    fns2 = [minimum, minimum, minimum, minimum, maximum, minimum, minimum, maximum]
    result2 = psi(decmat2, fns2)
    @test all(isapprox.(result2.scores, [0.8457, 0.8463, 0.8539, 0.8725], atol = 0.00006))
    @test result2.bestIndex == 4
end
