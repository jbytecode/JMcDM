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
    include("./testscdm.jl")
end # Test SCDM Tools 

@info "MCDM Tests ..."
if testMCDMFunctions
    include("./testmcdm.jl")
    include("./testcopeland.jl")
end  # Test MCDM Tools

@info "LP Based Tests (takes time) ..."
if testLPBasedFunctions
    include("./testlp.jl")
end # Test LP Based Tools
