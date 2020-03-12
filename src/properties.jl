
ImageCore.HasProperties(::Type{<:AbstractAxisIndices{T,N,P}}) where {T,N,P} = HasProperties(P)
ImageCore.HasProperties(::Type{<:NamedDimsArray{L,T,N,P}}) where {L,T,N,P} = HasProperties(P)
ImageCore.HasProperties(::Type{<:ImageMeta}) = HasProperties{true}()


ImageMetadata.properties(x::AbstractAxisIndices) = _properties(HasProperties(x), x)
ImageMetadata.properties(x::NamedDimsArray) = _properties(HasProperties(x), x)
_properties(::HasProperties{true}, x) = properties(parent(x))
_properties(::HasProperties{false}, x) = error("$(typeof(x)) does not have properties.")

function Base.hasproperty(x::AbstractAxisIndices{T,N,<:ImageMeta}, s::Symbol) where {T,N}
    return hasproperty(parent(x), s)
end
function Base.hasproperty(x::NamedDimsArray{L,T,N,<:AbstractAxisIndices{T,N,<:ImageMeta}}, s::Symbol) where {L,T,N}
    return hasproperty(parent(x), s)
end

function Base.getproperty(x::AbstractAxisIndices{T,N,<:ImageMeta}, s::Symbol) where {T,N}
    return getproperty(parent(x), s)
end
function Base.getproperty(x::NamedDimsArray{L,T,N,<:AbstractAxisIndices{T,N,<:ImageMeta}}, s::Symbol) where {L,T,N}
    return getproperty(parent(x), s)
end

function Base.setproperty!(x::AbstractAxisIndices{T,N,<:ImageMeta}, s::Symbol, val) where {T,N}
    return setproperty!(parent(x), s, val)
end
function Base.setproperty!(x::NamedDimsArray{L,T,N,<:AbstractAxisIndices{T,N,<:ImageMeta}}, s::Symbol, val) where {L,T,N}
    setproperty!(parent(x), s, val)
end

