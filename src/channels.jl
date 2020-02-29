
function ImageCore.permuteddimsview(nda::NamedDimsArray, perm)
    return NamedDimsArray(
        permuteddimsview(parent(nda), perm),
        NamedDims.permute_dimnames(dimnames(nda), perm)
    )
end

function ImageCore.permuteddimsview(x::AbstractAxisIndices, perm)
    p = permuteddimsview(parent(x), perm)
    axs = AxisIndices.permute_axes(x, perm)
    return AxisIndices.similar_type(x, typeof(p), typeof(axs))(p, axs)
end

function ImageCore.channelview(A::NamedDimsArray{L}) where {L}
    return _channelview(L, channelview(parent(A)))
end
_channelview(n::Tuple{Vararg{Symbol,N}}, a::AbstractArray{T,M}) where {T,N,M} = NamedDimsArray{(:color, n...,)}(a)
_channelview(n::Tuple{Vararg{Symbol,N}}, a::AbstractArray{T,N}) where {T,N} = NamedDimsArray{n}(a)

ImageCore.channelview(A::AbstractAxisIndices) = _channelview(A, channelview(parent(A)), axes(A))
function _channelview(A::AbstractAxisIndices, a::AbstractArray{T,N}, axs::Tuple{Vararg{<:AbstractAxis,N}}) where {T,N}
    return AxisIndices.similar_type(A, typeof(a), typeof(axs))(a, axs)
end
function _channelview(A::AbstractAxisIndices, a::AbstractArray{T,N}, axs::Tuple{Vararg{<:AbstractAxis,M}}) where {T,N,M}
    return _channelview(A, a, (AxisIndices.to_axis(A, axes(a, 1)), axs...,))
end

