
NamedDims.dimnames(::Type{<:StremingContainer{T,N,SN,<:NamedDimsArray{L,T,N}}}) where {L,T,N,SN} = L

function ImageAxes.isstreamedaxis(name::Symbol, S::StreamingContainer{T,N,saxnames}) where {name,T,N,saxnames}
    return in(name, saxnames)
end

