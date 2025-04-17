@testset "Fuzzy Topsis Trapezoidal  Example -(Fatih ECER,(2007))" verbose = true begin

    """
    Fatih, ECER.(2007). BULANIK ORTAMLARDA MAĞAZA KURULUŞ YERLERİNİN DEĞERLENDİRİLMESİ: 
    BİR KARAR VERME ARACI OLARAK BULANIK TOPSIS YÖNTEMİ. Hacettepe Üniversitesi İktisadi ve İdari 
    Bilimler Fakültesi Dergisi, 25(1), 143-170.
    """

    atol = 0.001

    decmat = [
        Trapezoidal(4.0, 6.3, 6.7, 9.0) Trapezoidal(7.0, 8.3, 8.7, 10.0) Trapezoidal(1.0, 3.3, 3.7, 6.0) Trapezoidal(8.0, 9.0, 10.0, 10.0) Trapezoidal(2.0, 5.3, 5.7, 9.0) Trapezoidal(2.0, 4.7, 5.3, 8.0)
        Trapezoidal(4.0, 5.3, 5.7, 8.0) Trapezoidal(7.0, 8.3, 8.7, 10.0) Trapezoidal(7.0, 8.3, 8.7, 10.0) Trapezoidal(2.0, 4.7, 5.3, 8.0) Trapezoidal(5.0, 7.7, 8.3, 10.0) Trapezoidal(7.0, 8.3, 8.7, 10.0)
        Trapezoidal(2.0, 4.0, 5.0, 8.0) Trapezoidal(7.0, 8.3, 8.7, 10.0) Trapezoidal(0.0, 1.7, 2.3, 5.0) Trapezoidal(7.0, 8.7, 9.3, 10.0) Trapezoidal(4.0, 5.3, 5.7, 8.0) Trapezoidal(2.0, 3.7, 4.3, 6.0)
        Trapezoidal(4.0, 6.3, 6.7, 10.0) Trapezoidal(7.0, 8.7, 9.3, 10.0) Trapezoidal(8.0, 9.0, 10.0, 10.0) Trapezoidal(0.0, 0.7, 1.3, 3.0) Trapezoidal(8.0, 9.0, 10.0, 10.0) Trapezoidal(8.0, 9.0, 10.0, 10.0)
    ]


    w = [
        Trapezoidal(0.40, 0.73, 0.77, 1.00)
        Trapezoidal(0.70, 0.87, 0.93, 1.00)
        Trapezoidal(0.80, 0.90, 1.00, 1.00)
        Trapezoidal(0.50, 0.77, 0.83, 1.00)
        Trapezoidal(0.70, 0.87, 0.93, 1.00)
        Trapezoidal(0.50, 0.70, 0.80, 1.00)
    ]

    fns = [maximum for _ = 1:6]

    result = fuzzytopsis(decmat, w, fns)

    @test isapprox(result.scores[1], 0.47746010424923985, atol = atol)
    @test isapprox(result.scores[2], 0.5577695733819615, atol = atol)
    @test isapprox(result.scores[3], 0.42214268828746054, atol = atol)
    @test isapprox(result.scores[4], 0.5614334226954862, atol = atol)

end
