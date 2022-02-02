@testset "Copeland" begin

    @testset "Copeland Example 1" begin
        """
        This example is interpreted from the results of 

        Arslan, Rahim, and Hüdaverdi Bircan. "Çok Kriterli Karar Verme Teknikleriyle Elde Edilen 
        Sonuçların Copeland Yöntemiyle Birleştirilmesi ve Karşılaştırılması." Yönetim ve Ekonomi: 
        Celal Bayar Üniversitesi İktisadi ve İdari Bilimler Fakültesi Dergisi 27.1 (2020): 109-127.

        for testing the method.
        """
        topsis_ord = [
            7,
            17,
            3,
            14,
            6,
            18,
            10,
            19,
            8,
            15,
            22,
            12,
            2,
            9,
            23,
            11,
            16,
            20,
            5,
            13,
            1,
            21,
            4,
        ]
        gia_ord = [
            9,
            17,
            3,
            14,
            6,
            18,
            7,
            19,
            8,
            16,
            22,
            13,
            1,
            10,
            23,
            11,
            15,
            20,
            5,
            12,
            2,
            21,
            4,
        ]
        vikor_ord = [
            7,
            17,
            3,
            14,
            5,
            18,
            10,
            19,
            8,
            16,
            22,
            13,
            1,
            9,
            23,
            11,
            15,
            20,
            6,
            12,
            2,
            21,
            4,
        ]
        mooraref_ord = [
            3,
            14,
            2,
            15,
            16,
            21,
            10,
            23,
            8,
            9,
            19,
            6,
            7,
            5,
            22,
            17,
            13,
            18,
            12,
            11,
            1,
            20,
            4,
        ]
        copras_ord = [
            7,
            17,
            3,
            14,
            6,
            18,
            11,
            19,
            8,
            15,
            22,
            12,
            1,
            9,
            23,
            10,
            16,
            20,
            5,
            13,
            2,
            21,
            4,
        ]
        moora_ord = [
            7,
            17,
            3,
            14,
            5,
            18,
            11,
            19,
            8,
            15,
            22,
            12,
            1,
            9,
            23,
            10,
            16,
            20,
            6,
            13,
            2,
            21,
            4,
        ]
        aras_ord = [
            7,
            17,
            3,
            14,
            6,
            18,
            11,
            19,
            8,
            15,
            22,
            12,
            1,
            9,
            23,
            10,
            16,
            20,
            5,
            13,
            2,
            21,
            4,
        ]

        mat = hcat(topsis_ord, gia_ord, vikor_ord, mooraref_ord)

        c = copeland(mat)

        d = c |> sortperm

        #show(d)
        #@info d

        @test d == [
            15,
            11,
            22,
            18,
            8,
            6,
            2,
            10,
            17,
            4,
            12,
            20,
            16,
            7,
            14,
            9,
            1,
            5,
            19,
            23,
            3,
            13,
            21,
        ]

    end


    @testset "Copeland Example 2" begin
        """
        This example is interpreted from the result of 

        Özdağoğlu, Aşkın, et al. "Combining different MCDM methods with the Copeland method: 
        An investigation on motorcycle selection." Journal of process management and new 
        technologies 9.3-4 (2021): 13-27.

        in this test.
        """
        mopa_rank = [1, 4, 2, 3]
        moosra_rank = [1, 2, 3, 4]
        copras_rank = [1, 3, 2, 4]
        saw_rank = [1, 3, 2, 4]
        wpm_rank = [1, 3, 2, 4]
        rov_rank = [4, 1, 2, 3]

        mopa_order = reverse(mopa_rank)
        moosra_order = reverse(moosra_rank)
        copras_order = reverse(copras_rank)
        saw_order = reverse(saw_rank)
        wpm_order = reverse(wpm_rank)
        rov_order = reverse(rov_rank)

        mat = hcat(mopa_order, moosra_order, copras_order, saw_order, wpm_order, rov_order)

        c = copeland(mat)

        d = c |> sortperm

        @test d == [1, 3, 2, 4]
    end

end
