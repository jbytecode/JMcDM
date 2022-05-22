using JMcDM

dmat = [
        #Rock   Paper   Scissors
           0     -1        1; 
           1      0       -1; 
          -1      1        0
]

@info game(dmat |> makeDecisionMatrix)

# GameResult([0.3333333333333334, 
              0.3333333333333333, 
              0.3333333333333333], 0.0)


