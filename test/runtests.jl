using Test

using JuMP, Ipopt, JMcDM

import JMcDM.Game: game
import JMcDM.DataEnvelop: dataenvelop
import JMcDM.SECA: seca

const testGreyNumbers       = true
const testUtilityFunctions  = true
const testMCDMFunctions     = true    
const testSCDMFunctions     = true
const testLPBasedFunctions  = true
const testGreyMCDMFunctions = true
const testSummary           = true
const testCopeland          = true

testGreyNumbers && include("./testgreynumber.jl")

testUtilityFunctions && include("./testutility.jl")

testSCDMFunctions && include("./testscdm.jl")

testMCDMFunctions && include("./testmcdm.jl")

testCopeland && include("./testcopeland.jl")

testGreyMCDMFunctions && include("./testgreymcdm.jl")

testLPBasedFunctions && include("./testlp.jl")

testSummary && include("./testsummary.jl")
 
