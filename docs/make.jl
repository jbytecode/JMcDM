
using Documenter, JMcDM, Ipopt, JuMP

import JMcDM.Fuzzy 

makedocs(
         format = Documenter.HTML(
                                  prettyurls = get(ENV, "CI", nothing) == "true",
                                  collapselevel = 2,
                                  # assets = ["assets/favicon.ico", "assets/extra_styles.css"],
                                 ),
         sitename="JMcDM: Julia package for multiple-criteria decision making",
         authors = "Mehmet Hakan Satman, Bahadır Fatih Yıldırım, Ersagun Kuruca",
         pages = [
                  "MCDM" => "mcdms.md",
                  "Normalization Methods" => "normalizations.md",
                  "Game Solver" =>  "game.md",
                  "Data Envelopment" => "dataenvelop.md",
                  "SCDM" => "scdm.md",
		  "Utility" => "utility.md",
                  "Grey Numbers" => "greynumbers.md",
                  "Fuzzy Methods" => "fuzzy.md",
                 ]
        )


deploydocs(
           repo = "github.com/jbytecode/JMcDM",
          )
