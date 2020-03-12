
module ColorData

using ImageCore, NamedDims, ImageAxes, AxisIndices, NamedIndicesMeta

import ImageAxes: colordim

export
    is_color,
    # @defdim output
    colordim,
    has_colordim,
    color_axis,
    color_axis_type,
    color_keys,
    color_indices,
    to_color_format,
    ncolor,
    color_format,
    # reexport
    permuteddimsview,
    channelview

Base.@pure is_color(x::Symbol) = x === :color

@defdim color is_color

function ImageCore.permuteddimsview(nda::NamedDimsArray, perm)
    return NamedDimsArray(
        permuteddimsview(parent(nda), perm),
        NamedDims.permute_dimnames(dimnames(nda), perm)
    )
end

function ImageCore.permuteddimsview(x::AbstractAxisIndices, perm)
    return AxisIndices.unsafe_reconstruct(
        x,
        permuteddimsview(parent(x), perm),
        AxisIndices.permute_axes(x, perm)
    )
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
    return _channelview(A, a, (AxisIndices.as_axis(A, axes(a, 1)), axs...,))
end

end
