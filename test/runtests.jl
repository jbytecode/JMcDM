using Test
import DataFrames: DataFrame, DataFrameRow


using JMcDM

const testUtilityFunctions = true
const testMCDMFunctions = true
const testSCDMFunctions = true
const testLPBasedFunctions = true 



if testUtilityFunctions
    include("./testutility.jl")
end


if testSCDMFunctions
    @info "SCDM tests ..."
    include("./testscdm.jl")
end # Test SCDM Tools 

if testMCDMFunctions
    @info "MCDM Tests ..."
    include("./testmcdm.jl")
    include("./testcopeland.jl")
end  # Test MCDM Tools

@info "LP Based Tests (takes time) ..."
if testLPBasedFunctions
    include("./testlp.jl")
end # Test LP Based Tools
