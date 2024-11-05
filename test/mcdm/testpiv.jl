@testset "PIV" begin
    tol = 0.0001

    decmat = [
        60 2.5 2540 500 990
        6.35 6.667 1016 3000 1041
        6.8 10 1727 1500 1676
        10 5 1000 2000 965
        2.5 9.8 560 500 915
        4.5 12.5 1016 350 508
        3 10 1778 1000 920
    ]

    w = [0.1761, 0.2042, 0.2668, 0.1243, 0.2286]

    fns = [maximum, maximum, maximum, maximum, maximum]
    fns2 = [minimum for i ∈ 1:5]

    result = piv(decmat, w, fns)
    result2 = piv(decmat, w, fns2)

    @test result2 isa PIVResult

    @test result isa PIVResult
    @test isapprox(
        result.scores,
        [
            0.22086675609968962,
            0.35854940101222144,
            0.2734184099704686,
            0.4005382183676046,
            0.4581157878699193,
            0.43595371718873477,
            0.3580651803072459,
        ],
        atol = tol,
    )
    @test result.bestIndex == 1
    @test result.ranking == [1, 3, 7, 2, 4, 6, 5]
end