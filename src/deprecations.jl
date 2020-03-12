
export
    spatialorder,
    coords_spatial,
    size_spatial,
    spacedirections,
    pixelspacing,
    indices_spatial

@deprecate(spatialorder(x::AbstractArray), spatial_order(x))

@deprecate(coords_spatial(x::AbstractArray), spatialdims(x))

@deprecate(size_spatial(x::AbstractArray), spatial_size(x))

@deprecate(indices_spatial(x::AbstractArray), spatial_indices(x))

@deprecate(spacedirections(x::AbstractArray), spatial_directions(x))

@deprecate(pixelspacing(x), pixel_spacing(x))
