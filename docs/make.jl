using Documenter

using Pkg
Pkg.activate("../")
using JMcDM

push!(LOAD_PATH,"../src/")
makedocs(
	sitename="JMcDM",
	pages=[
		"mcdms.md", "game.md", "dataenvelop.md"
	]
)

