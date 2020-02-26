
function ImageCore.permuteddimsview(nda::NamedDimsArray, perm)
    return NamedDimsArray(permuteddimsview(parent(nda), perm),
                          NamedDims.permute_dimnames(dimnames(nda), perm))
end

function ImageCore.permuteddimsview(x::AxisIndicesArray, perm)
    return AxisIndicesArray(permuteddimsview(parent(x), perm), AxisIndices.permute_axes(x, perm))
end

function ImageCore.channelview(A::NamedDimsArray{L}) where {L}
    return _channelview(L, channelview(parent(A)))
end
_channelview(n::Tuple{Vararg{Symbol,N}}, a::AbstractArray{T,M}) where {T,N,M} = NamedDimsArray{(:color, n...,)}(a)
_channelview(n::Tuple{Vararg{Symbol,N}}, a::AbstractArray{T,N}) where {T,N} = NamedDimsArray{n}(a)

ImageCore.channelview(A::AxisIndicesArray) = _channelview(axes(A), channelview(parent(A)))
function _channelview(axs::Tuple{Vararg{<:AbstractAxis,N}}, a::AbstractArray{T,N}) where {T,N}
    return AxisIndicesArray(a, axs)
end
function _channelview(axs::Tuple{Vararg{<:AbstractAxis,N}}, a::AbstractArray{T,M}) where {T,M,N}
    return AxisIndicesArray(a, (axes(a, 1), axs...,))
end

