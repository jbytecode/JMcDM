@testset "ROV" begin
    tol = 0.01
    mat = [
        0.035 34.5 847 1.76 0.335 0.5 0.59 0.59
        0.027 36.8 834 1.68 0.335 0.665 0.665 0.665
        0.037 38.6 808 2.4 0.59 0.59 0.41 0.5
        0.028 32.6 821 1.59 0.5 0.59 0.59 0.41
    ]


    w = [0.3306, 0.0718, 0.1808, 0.0718, 0.0459, 0.126, 0.126, 0.0472]

    fns = [minimum, minimum, minimum, minimum, maximum, minimum, minimum, maximum]

    result1::ROVResult = rov(mat, w, fns)


    @test result1 isa ROVResult
    @test isapprox(
        result1.uminus,
        [
            0.3349730210602759,
            0.4762288888888889,
            0.3640727272727273,
            0.6560048841354725,
        ],
        atol = tol,
    )
    @test isapprox(
        result1.uplus,
        [0.03331764705882352, 0.0472, 0.06255882352941176, 0.029700000000000004],
        atol = tol,
    )

    @test isapprox(
        result1.scores,
        [
            0.1841453340595497,
            0.26171444444444447,
            0.21331577540106955,
            0.34285244206773624,
        ],
        atol = tol,
    )

    @test result1.ranks == [4, 2, 3, 1]


    setting = MCDMSetting(mat, w, fns)
    result2 = mcdm(setting, ROVMethod())
    @test result2.ranks == result1.ranks
    @test result2.scores == result1.scores
    @test result2 isa ROVResult
end