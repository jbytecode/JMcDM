using JMcDM

df = [
    100.0 200 300 400;
    1 2 3 4;
    2 4 6 8;
    5 7 8 2;
]
        functionlist = makeminmax([maximum, maximum, maximum, maximum])

        w = [0.25, 0.25, 0.25, 0.25] 

    row, col = size(df)
    greydec = Array{GreyNumber, 2}(undef, row, col)
    for i in 1:row 
        for j in 1:col 
            greydec[i, j] = GreyNumber(Float64(df[i, j]))
        end
    end


    greydf = makeDecisionMatrix(greydec)
    println(greydf)
    result = electre(greydf, w,  functionlist)
