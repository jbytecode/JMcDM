using Test

using JuMP, Ipopt, JMcDM

import JMcDM.Game: game
import JMcDM.DataEnvelop: dataenvelop
import JMcDM.SECA: seca

const testGreyNumbers       =  true
const testUtilityFunctions  =  true
const testMCDMFunctions     =  true
const testSCDMFunctions     =  true
const testLPBasedFunctions  =  true
const testGreyMCDMFunctions =  true
const testSummary           =  true

include("testcilos.jl")

testGreyNumbers && include("./testgreynumber.jl")

testUtilityFunctions && include("./testutility.jl")

testSCDMFunctions && include("./testscdm.jl")


testMCDMFunctions && let 
    include("./testmcdm.jl")
    include("./testcopeland.jl")
end  

testGreyMCDMFunctions && include("./testgreymcdm.jl")


testLPBasedFunctions && include("./testlp.jl")


testSummary && include("./testsummary.jl")
 
