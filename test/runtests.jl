using Test
import DataFrames: DataFrame, DataFrameRow


using JMcDM

const testUtilityFunctions    = true
const testMCDMFunctions       = true
const testSCDMFunctions       = true
const testLPBasedFunctions    = true 
const testGreyMCDMFunctions   = true 


if testUtilityFunctions
    @info "Utility tests ..."
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

if testGreyMCDMFunctions
    @info "Grey MCDM Tests ..."
    include("./testgreymcdm.jl")
end # Test Grey MCDM Toolk

@info "LP Based Tests (takes time) ..."
if testLPBasedFunctions
    include("./testlp.jl")
end # Test LP Based Tools
