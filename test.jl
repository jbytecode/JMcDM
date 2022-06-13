using JMcDM

df = DataFrame(
            :K1 => [105000.0, 120000, 150000, 115000, 135000],
            :K2 => [105.0, 110, 120, 105, 115],
            :K3 => [10.0, 15, 12, 20, 15],
            :K4 => [4.0, 4, 3, 4, 5],
            :K5 => [300.0, 500, 550, 600, 400],
            :K6 => [10.0, 8, 12, 9, 9],
        )
        functionlist = [minimum, maximum, minimum, maximum, maximum, minimum]

        w = [0.05, 0.20, 0.10, 0.15, 0.10, 0.40]

        gdf = makegrey(Matrix(df))
        result = aras(makeDecisionMatrix(gdf), w, functionlist)

        @show result 
