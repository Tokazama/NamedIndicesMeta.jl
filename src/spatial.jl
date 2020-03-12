
module SpatialData

using NamedDims, ImageCore, AxisIndices, NamedIndicesMeta

using NamedIndicesMeta.ColorData

using NamedIndicesMeta.TimeData

using NamedIndicesMeta.ObservationData

using Base: tail

export
    spatial_order,
    spatialdims,
    spatial_axes,
    spatial_units,
    spatial_offset,
    spatial_keys,
    spatial_indices,
    spatial_size,
    spatial_directions,
    spatial_units,
    pixel_spacing

"""
    spatial_order(x) -> Tuple{Vararg{Symbol}}
"""
spatial_order(x::X) where {X} = _spatial_order(Val(dimnames(X)))
@generated function _spatial_order(::Val{L}) where {L}
    # 0-Allocation see:
    # `@btime (()->remaining_dimnames_from_indexing((:a, :b, :c), (:,390,:)))()``
    keep_names = []
    for n in L
        if !(is_time(n) | is_color(n) | is_observation(n))
            push!(keep_names, n)
        end
    end
    out = (keep_names...,)
    quote
        return $out
    end
end

"""
    spatialdims(x) -> Tuple{Vararg{Int}}

Return a tuple listing the spatial dimensions of `img`.
Note that a better strategy may be to use ImagesAxes and take slices along the time axis.
"""
@inline spatialdims(x) = dim(dimnames(x), spatial_order(x))

"""
    spatial_axes(x) -> Tuple
"""
@inline spatial_axes(x) = _spatial_axes(named_axes(x), spatial_order(x))
function _spatial_axes(na::NamedTuple, spo::Tuple{Vararg{Symbol}})
    return map(spo_i -> getfield(na, spo_i), spo)
end

"""
    spatial_size(x) -> Tuple{Vararg{Int}}

Return a tuple listing the sizes of the spatial dimensions of the image.
"""
@inline spatial_size(x) = map(length, spatial_axes(x))

"""
    spatial_indices(x)

Return a tuple with the indices of the spatial dimensions of the
image. Defaults to the same as `indices`, but using ImagesAxes you can
mark some axes as being non-spatial.
"""
@inline spatial_indices(x) = map(values, spatial_axes(x))

"""
    spatial_keys(x)
"""
@inline spatial_keys(x) = map(keys, spatial_axes(x))

"""
    pixel_spacing(x)
"""
@inline pixel_spacing(x) = map(step, spatial_keys(x))
#@inline ImageCore.pixel_spacing(x::NamedDimsArray) = map(step, spatial_keys(x))

ImageCore.spacedirections(x::NamedDimsArray) = ImageCore._spacedirections(pixel_spacing(x))

spatial_eltype(x) = map(eltype, spatial_axes(x))

"""
    spatial_units(x)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = map(unit, spatial_eltype(x))

"""
    spatial_offset(x)

The offset of each dimension (i.e., where each spatial axis starts).
"""
spatial_offset(x) = map(first, spatial_keys(x))

"""
    spatial_directions(img) -> (axis1, axis2, ...)

Return a tuple-of-tuples, each `axis[i]` representing the displacement
vector between adjacent pixels along spatial axis `i` of the image
array, relative to some external coordinate system ("physical
coordinates").

By default this is computed from `pixel_spacing`, but you can set this
manually using ImagesMeta.
"""
@inline function spatial_directions(x::X) where {X}
    return _spatial_directions(HasProperties(X), x)
end

function _spatial_directions(::HasProperties{false}, x::AbstractArray{T,N}) where {T,N}
    return _default_spatial_directions(pixel_spacing(x))
end
function _spatial_directions(::HasProperties{true}, x::AbstractArray{T,N}) where {T,N}
    if hasproperty(x, :spatial_directions)
        return getproperty(x, :spatial_directions)
    else
        return _default_spatial_directions(pixel_spacing(x))
    end
end
function _default_spatial_directions(ps::NTuple{N,Any}) where N
    return ntuple(i->ntuple(d->d==i ? ps[d] : zero(ps[d]), Val(N)), Val(N))
end

end

