
function ImageCore.spatialorder(::NamedDimsArray{L}) where {L}
    return Base.diff_names(L, (:time, :color, :channels, :frequency, :observations))
end

"""
    spatial_axes(x) -> Tuple
"""
@inline spatial_axes(x) = _spatial_axes(x, spatialorder(x))
_spatial_axes(x, spo::Tuple{Vararg{Symbol}}) = (axes(x, first(spo)), _spatial_axes(x, tail(spo))...)
_spatial_axes(x, spo::Tuple{}) = ()


#@inline spatialdims(x) = dim(dimnames(x), spatialorder(x))

ImageCore.size_spatial(x::NamedDimsArray) = map(length, spatial_axes(x))

ImageCore.indices_spatial(x::NamedDimsArray) = map(values, spatial_axes(x))

ImageCore.coords_spatial(x::NamedDimsArray{L}) where {L} = dim(L, spatialorder(x))

@inline spatial_keys(x) = map(keys, spatial_axes(x))

@inline ImageCore.pixelspacing(x::NamedDimsArray) = map(step, spatial_keys(x))

ImageCore.spacedirections(x::NamedDimsArray) = ImageCore._spacedirections(pixelspacing(x))

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
spatial_offset(x) = map(first, spatial_axes(x))
