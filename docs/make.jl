
		"mcdms.md", "game.md", "dataenvelop.md", "scdm.md", "utility.md"


using Documenter, Sqlite3Stats

makedocs(
         format = Documenter.HTML(
                                  prettyurls = get(ENV, "CI", nothing) == "true",
                                  collapselevel = 2,
                                  # assets = ["assets/favicon.ico", "assets/extra_styles.css"],
                                  # analytics = "UA-xxxxxxxxx-x",
                                 ),
         sitename="JMcDM: Julia package for multiple-criteria decision making",
         authors = ["Mehmet Hakan Satman", "Bahadır Fatih Yıldırım", "Ersagun Kuruca"],
         pages = [
                  "MCDM" => "mcdms.md",
                  "Game Solver" =>  "game.md",
                  "Data Envolepment" => "dataenvelop.md",
                  "SCDM" => "scdm.md",
				  "Utility" => "utility.md"
                 ]
        )


deploydocs(
           repo = "github.com/jbytecode/jmcdm",
          )