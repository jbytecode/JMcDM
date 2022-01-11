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
    println(io, result.weigths)
end

function Base.show(io::IO, result::CODASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end


function Base.show(io::IO, result::COPRASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::CRITICResult)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::CoCoSoResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::EDASResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
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
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MAIRCAResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::MARCOSResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
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
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::SawResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
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
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end

function Base.show(io::IO, result::WPMResult)
    println(io, "Scores:")
    println(io, result.scores)
    println(io, "Ranking: ")
    println(io, result.ranking)
    println(io, "Best indices:")
    println(io, result.bestIndex)
end





