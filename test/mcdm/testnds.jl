@testset "NDS" begin
    @testset "NDS - all maximum" begin
        cases = [
            1.0 2.0 3.0
            2.0 1.0 3.0
            1.0 3.0 2.0
            4.0 5.0 6.0
        ]


        fns = [maximum, maximum, maximum]

        result = nds(cases, fns)

        @test isa(result, NDSResult)

        @test result.bestIndex == 4

        @test result.ranks == [0, 0, 0, 3]
    end

    @testset "NDS - all minimum" begin
        cases = [
            1.0 2.0 3.0 4.0
            2.0 4.0 6.0 8.0
            4.0 8.0 12.0 16.0
            8.0 16.0 24.0 32.0
        ]

        nd = cases

        fns = [minimum, minimum, minimum, minimum]

        result = nds(nd, fns)

        @test isa(result, NDSResult)

        @test result.bestIndex == 1

        @test result.ranks == [3, 2, 1, 0]
    end
end