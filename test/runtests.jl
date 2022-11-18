using Test


using JuMP, GLPK, JMcDM, DataFrames

import JMcDM.Game: game
import JMcDM.DataEnvelop: dataenvelop


const testGreyNumbers          = true
const testUtilityFunctions     = true
const testMCDMFunctions        = true
const testSCDMFunctions        = true
const testLPBasedFunctions     = true
const testGreyMCDMFunctions    = true
const testSummary              = true


if testGreyNumbers
    @info "Grey Numbers tests ..."
    include("./testgreynumber.jl")
end


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
end # Test Grey MCDM Tools

if testLPBasedFunctions
    @info "LP Based Tests (takes time) ..."
    include("./testlp.jl")
end # Test LP Based Tools

if testSummary
    @info "Summary Tests ..."
    include("./testsummary.jl")
end # Test Summary Tools

