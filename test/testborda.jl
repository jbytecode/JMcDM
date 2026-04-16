@testset "Borda" verbose=true begin 

    @testset "Toy example" begin
        orderingMat = [1 2 3;
                       2 1 2;
                       3 3 1;]
        result = borda(orderingMat)
        # alternative 2 has the lowest total score (1+1+3=5), 
        # followed by alternative 1 (2+2+3=7), and then alternative 3 (3+3+1=7)
        @test result == [2, 1, 3] 
    end

    @testset "A bigger (and more realistic) example" begin 
        m1_ordering = [1, 2, 3, 4, 5, 6]
        m2_ordering = [2, 1, 3, 4, 5, 6]
        m3_ordering = [4, 3, 1, 2, 6, 5]
        m4_ordering = [4, 3, 2, 1, 6, 5]
        orderingMat = hcat(m1_ordering, m2_ordering, m3_ordering, m4_ordering)
        # Ordering Mat is :
        # 1 2 4 4
        # 2 1 3 3
        # 3 3 1 2
        # 4 4 2 1
        # 5 5 6 6
        # 6 6 5 5
        # Alternative 1 has a total score of 1+2+4+4=11
        # Alternative 2 has a total score of 2+1+3+3=9
        # Alternative 3 has a total score of 3+3+1+2=9
        # Alternative 4 has a total score of 4+4+2+1=11
        # Alternative 5 has a total score of 5+5+6+6=22
        # Alternative 6 has a total score of 6+6+5+5=22
        
        result = borda(orderingMat)

        @test result[1] in [2, 3] # Alternative 2 and 3 are tied for the best rank
        @test result[2] in [2, 3] # Alternative 2 and 3 are tied for the best rank
        @test result[3] in [1, 4] # Alternative 1 and 4 are tied for the second rank
        @test result[4] in [1, 4] # Alternative 1 and 4 are tied for the second rank
        @test result[5] in [5, 6] # Alternative 5 and 6 are tied for the worst rank
        @test result[6] in [5, 6] # Alternative 5 and 6 are tied for the worst rank
    end 
end 