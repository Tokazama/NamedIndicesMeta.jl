module NamedIndicesMeta

using NamedDims, ImageCore, ImageMetadata, ImageAxes, FieldProperties, AxisIndices

export
    NIMArray,
    NIArray,
    IMArray,
    has_time_axis,
    spatialaxes,
    # reexports
    properties

#=
Design decision:
indices_* : the numbers that index the array directly
*axis : the keys corresponding to the indices
=#

###

function finddim(f::Function, x)
    for (i,n) in enumerate(dimnames(x))
        f(n) && return i
    end
    return nothing
end

# TODO this should go in NamedDims
named_axes(x) = NamedTuple{dimnames(x)}(axes(x))

include("types.jl")
include("image_metadata.jl")
include("image_core.jl")
include("image_axes.jl")

end # module

