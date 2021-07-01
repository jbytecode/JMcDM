
function mcdm(df::DataFrame, 
    w::Array{Float64, 1}, 
    fns::Array{Function, 1}, 
    method::T1)::MCDMResult where {T1 <: MCDMMethod}

    if method isa TopsisMethod
        topsis(df, w, fns)
    elseif method isa ElectreMethod
        electre(df, w, fns)
    elseif method isa ArasMethod
        aras(df, w, fns)
    elseif method isa CocosoMethod
        cocoso(df, w, fns, lambda = method.lambda)  
    elseif method isa CodasMethod
        codas(df, w, fns, tau = method.tau)
    elseif method isa CoprasMethod
        copras(df, w, fns)
    elseif method isa CriticMethod
        critic(df, fns)
    elseif method isa EdasMethod
        edas(df, w, fns)
    elseif method isa GreyMethod
        grey(df, w, fns, zeta = method.zeta)
    elseif method isa MabacMethod 
        mabac(df, w, fns)
    elseif method isa MaircaMethod 
        mairca(df, w, fns)
    elseif method isa MooraMethod
        moora(df, w, fns)
    elseif method isa PrometheeMethod
        promethee(df, w, fns, method.pref, method.qs, method.ps)
    elseif method isa SawMethod
        saw(df, w, fns)
    elseif method isa VikorMethod
        vikor(df, w, fns, v = method.v)
    elseif method isa WaspasMethod
        waspas(df, w, fns, method.lambda)
    elseif method isa WPMMethod 
        wpm(df, w, fns)
    else
        error("Method is not defined") 
    end 
end 



function mcdm(setting::MCDMSetting, 
    method::T1)::MCDMResult where {T1 <: MCDMMethod}

    mcdm(
        setting.df,
        setting.weights,
        setting.fns, 
        method
    )
end 