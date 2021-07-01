abstract type MCDMMethod end 

struct TopsisMethod <: MCDMMethod end

struct ElectreMethod <: MCDMMethod 
end 


struct ArasMethod <: MCDMMethod 
end 


struct CocosoMethod <: MCDMMethod
    lambda::Float64
end

CocosoMethod()::CocosoMethod = CocosoMethod(0.5)
CocosoMethod(lambda::Float64)::CocosoMethod = CocosoMethod(lambda)

struct CodasMethod <: MCDMMethod
    tau::Float64
end

CodasMethod()::CodasMethod = CodasMethod(0.02)
CodasMethod(tau::Float64)::CodasMethod = CodasMethod(tau)

struct CoprasMethod <: MCDMMethod 
end 


struct CriticMethod <: MCDMMethod 
end 


struct EdasMethod <: MCDMMethod 
end 


struct GreyMethod <: MCDMMethod 
    zeta::Float64
end 

GreyMethod() :: GreyMethod = GreyMethod(0.5)
GreyMethod(zeta::Float64) :: GreyMethod = GreyMethod(zeta)

struct MabacMethod <: MCDMMethod 
end 


struct MaircaMethod <: MCDMMethod 
end 


struct MooraMethod <: MCDMMethod 
end 


struct PrometheeMethod <: MCDMMethod 
    pref::Array{Function, 1}
    qs::Array{Float64, 1}
    ps::Array{Float64, 1}
end 

PrometheeMethod(pref::Array{Function, 1}, qs::Array{Float64,1}, ps::Array{Float64, 1}) :: PrometheeMethod = PrometheeMethod(pref, qs, ps)

struct SawMethod <: MCDMMethod 
end 


struct VikorMethod <: MCDMMethod
    v::Float64
end 

VikorMethod()::VikorMethod = VikorMethod(0.5)
VikorMethod(v::Float64) = VikorMethod(v)


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
    else
        error("Method is not defined") 
    end 
end 