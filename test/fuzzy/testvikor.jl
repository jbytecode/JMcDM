

@testset "Fuzzy Vikor" verbose = true begin

    eps = 0.001

    decmat = [
        Triangular(5.67, 7.67, 9.33) Triangular(6.33, 8.00, 9.33) Triangular(3.00, 5.00, 7.00) Triangular(9.00, 10.0, 10.0) Triangular(3.67, 5.67, 7.67);
        Triangular(5.00, 7.00, 8.67) Triangular(3.67, 5.67, 7.67) Triangular(3.00, 4.00, 5.33) Triangular(6.33, 8.33, 9.67) Triangular(1.67, 3.67, 5.67);
        Triangular(8.33, 9.67, 10.0) Triangular(8.33, 9.67, 10.0) Triangular(2.33, 4.33, 6.33) Triangular(5.00, 7.00, 8.67) Triangular(8.33, 9.67, 10.0);
        Triangular(1.67, 3.67, 5.67) Triangular(1.67, 3.67, 5.67) Triangular(7.67, 9.33, 10.0) Triangular(2.33, 4.33, 6.33) Triangular(3.00, 5.00, 7.00);
        Triangular(1.67, 3.67, 5.67) Triangular(8.33, 9.67, 10.0) Triangular(3.67, 5.67, 7.67) Triangular(8.33, 9.67, 10.0) Triangular(2.33, 4.33, 6.33)
    ]

    n, p = size(decmat)

    w = [
        Triangular(0.77, 0.93, 1.00),
        Triangular(0.50, 0.70, 0.87),
        Triangular(0.63, 0.80, 0.93),
        Triangular(0.23, 0.43, 0.63),
        Triangular(0.63, 0.83, 0.97)
    ]

    fns = [maximum, maximum, maximum, maximum, maximum]

    fplus_expected = Triangular[
        Triangular(8.33, 9.67, 10.00),
        Triangular(8.33, 9.67, 10.00),
        Triangular(7.67, 9.33, 10.00),
        Triangular(9.00, 10.00, 10.00),
        Triangular(8.33, 9.67, 10.00)
    ]

    fminus_expected = Triangular[
        Triangular(1.67, 3.67, 5.67),
        Triangular(1.67, 3.67, 5.67),
        Triangular(2.33, 4.00, 5.33),
        Triangular(2.33, 4.33, 6.33),
        Triangular(1.67, 3.67, 5.67)
    ]

    result = fuzzyvikor(decmat, w, fns)

    @test result isa FuzzyVikorResult

    # Test fplus vector
    for i in 1:p
        @test isapprox(result.fplus[i], fplus_expected[i], atol=eps)
    end

    # Test fminus vector
    for i in 1:p
        @test isapprox(result.fminus[i], fminus_expected[i], atol=eps)
    end

end