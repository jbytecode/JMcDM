"""
        sd(decisionMat, fns)

Apply SD method for a given matrix and directions of optimization.

# Arguments:
 - `decisionMat::DataFrame`: n × m matrix of objective values for n alternatives and m criteria 
 - `fns::Array{Function, 1}`: m-vector of functions to be applied on the columns.

# Description 
sd() applies the SD method to calculate weights for a set of given criteria.

# Output 
- `::SDResult`: SDResult object that holds weights.

# References
AYDIN, Yüksel. "A hybrid multi-criteria decision making (MCDM) model consisting of SD and 
COPRAS methods in performance evaluation of foreign deposit banks." Equinox Journal of 
Economics Business and Political Studies 7.2 (2020): 160-176.

Diakoulaki, Danae, George Mavrotas, and Lefteris Papayannakis. "Determining objective weights 
in multiple criteria problems: The critic method." Computers & Operations Research 22.7 
(1995): 763-770.
"""
function sd(decisionMat::DataFrame, fns::Array{Function,1})::SDResult
    
   n, p = size(decisionMat)

   decmat = decisionMat[:,:]
   normalizedMat = similar(decmat)
   
   cmins = colmins(decisionMat)
   cmaxs = colmaxs(decisionMat)

   for j in 1:p
        if fns[j] == maximum 
            normalizedMat[:,j] .= (decmat[:,j] .- cmins[j]) ./ (cmaxs[j] - cmins[j]) 
        elseif fns[j] == minimum 
            normalizedMat[:,j] .= (cmaxs[j] .- decmat[:,j]) ./ (cmaxs[j] - cmins[j]) 
        else
            @warn fns[j]
            error("Function must be either maximum or minimum.")
        end
   end 

   sds = map(ccol -> std(normalizedMat[:, ccol]), 1:p)
   sumsds = sum(sds)

   for i in 1:p
        sds[i] = sds[i] / sumsds 
   end 

   return(
       SDResult(
           sds 
       )
   )
end


"""
        critic(setting)

Apply SD method for a given matrix and criteria types.

# Arguments:
 - `setting::MCDMSetting`: MCDMSetting object. 
"""
function sd(setting::MCDMSetting)::SDResult
    sd(
        setting.df, 
        setting.fns
    )
end 