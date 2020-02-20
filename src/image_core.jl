
function ImageCore.permuteddimsview(nda::NamedDimsArray, perm)
    return NamedDimsArray(permuteddimsview(parent(nda), perm),
                          NamedDims.permute_dimnames(dimnames(nda), perm))
end

function ImageCore.permuteddimsview(x::AxisIndicesArray, perm)
    return AxisIndicesArray(permuteddimsview(parent(x), perm), AxisIndices.permute_axes(x, perm))
end

function ImageCore.nimages(nda::NamedDimsArray)
    d = NamedDims.dim_noerror(dimnames(nda), :time)
    if d === 0
        return 1
    else
        return size(nda, d)
    end
end

function _spatialorder(n::Tuple{Vararg{Symbol}})
    return Base.diff_names(n, (:time, :color, :channels, :frequency, :observations))
end

ImageCore.spatialorder(::NamedDimsArray{L}) where {L} = _spatialorder(L)

ImageCore.coords_spatial(::NamedDimsArray{L}) where {L} = dim(L, _spatialorder(L))

ImageCore.size_spatial(nda::NamedDimsArray) = map(i -> size(nda, i), spatialorder(nda))

ImageCore.indices_spatial(nda::NamedDimsArray) = map(i -> values(axes(nda, i)), spatialorder(nda))

@inline spatialaxes(x) = map(i -> keys(axes(x, i)), spatialorder(x))

@inline ImageCore.pixelspacing(nda::NamedDimsArray) = map(step, spatialaxes(nda))

ImageCore.spacedirections(nda::NamedDimsArray) = ImageCore._spacedirections(pixelspacing(nda))

function ImageCore.assert_timedim_last(img::NamedDimsArray{L}) where {L}
    last(L) === :time || error("time dimension is not last")
    nothing
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

