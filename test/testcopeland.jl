@testset "Copeland" begin
    """
    This example is interpreted from the results of 
    
    Arslan, Rahim, and Hüdaverdi Bircan. "Çok Kriterli Karar Verme Teknikleriyle Elde Edilen 
    Sonuçların Copeland Yöntemiyle Birleştirilmesi ve Karşılaştırılması." Yönetim ve Ekonomi: 
    Celal Bayar Üniversitesi İktisadi ve İdari Bilimler Fakültesi Dergisi 27.1 (2020): 109-127.

    for testing the method.
    """
     topsis_ord =
        [7, 17, 3, 14, 6, 18, 10, 19, 8, 15, 22, 12, 2, 9, 23, 11, 16, 20, 5, 13, 1, 21, 4]
     gia_ord =
        [9, 17, 3, 14, 6, 18, 7, 19, 8, 16, 22, 13, 1, 10, 23, 11, 15, 20, 5, 12, 2, 21, 4]
     vikor_ord =
        [7, 17, 3, 14, 5, 18, 10, 19, 8, 16, 22, 13, 1, 9, 23, 11, 15, 20, 6, 12, 2, 21, 4]
     mooraref_ord =
        [3, 14, 2, 15, 16, 21, 10, 23, 8, 9, 19, 6, 7, 5, 22, 17, 13, 18, 12, 11, 1, 20, 4]
     copras_ord =
        [7, 17, 3, 14, 6, 18, 11, 19, 8, 15, 22, 12, 1, 9, 23, 10, 16, 20, 5, 13, 2, 21, 4]
     moora_ord =
        [7, 17, 3, 14, 5, 18, 11, 19, 8, 15, 22, 12, 1, 9, 23, 10, 16, 20, 6, 13, 2, 21, 4]
     aras_ord =
        [7, 17, 3, 14, 6, 18, 11, 19, 8, 15, 22, 12, 1, 9, 23, 10, 16, 20, 5, 13, 2, 21, 4]

     mat = hcat(topsis_ord, gia_ord, vikor_ord, mooraref_ord)

    c = copeland(mat)    
    
    d = c |> sortperm
   
    @test d == [13, 21, 3, 23, 19, 5, 1, 9, 14, 7, 16, 12, 20, 4, 10, 17, 2, 6, 8, 18, 22, 11, 15]
    
end
