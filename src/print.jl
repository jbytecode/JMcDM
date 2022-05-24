function Base.show(io::IO, result::TopsisResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::ARASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Orderings: ")
    println(io, result.orderings)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::SDResult)
    println(io, "Weights:")
    println(io, result.weights)
end

function Base.show(io::IO, result::CODASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end


function Base.show(io::IO, result::COPRASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::CRITICResult)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::CoCoSoResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::EDASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::ElectreResult)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::GreyResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ordering)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MABACResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MAIRCAResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MARCOSResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MooraResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::PrometheeResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::SawResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::VikorResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::WASPASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::WPMResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::ROVResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: ")
    println(io, result.ranks)
    println(io, "Uminus:")
    println(io, result.uminus)
    println(io, "UPlus:")
    println(io, result.uplus)
end

function Base.show(io::IO, result::PSIResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: (from worst to best)")
    println(io, result.rankings)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MoosraMethod)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ordering: (from worst to best)")
    println(io, result.rankings)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end


