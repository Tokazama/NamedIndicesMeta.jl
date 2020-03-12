module NamedIndicesMeta

using NamedDims, ImageCore, ImageMetadata, ImageAxes, FieldProperties,
      AxisIndices, LightGraphs, SimpleWeightedGraphs, Reexport, MappedArrays
using Base: tail

import ImageAxes: timeaxis, timedim, colordim, checknames, isstreamedaxis

export
    NamedDimsArray,
    AxisIndicesArray,
    NIMArray,
    NIArray,
    IMArray,
    MetaArray,
    properties,
    dimnames,
    getdim,
    named_axes,
    @defdim

include("types.jl")
include("properties.jl")
include("data_format.jl")
include("defdim.jl")

include("time.jl")
using .TimeData

include("color.jl")
using .ColorData

include("observation.jl")
using .ObservationData

include("spatial.jl")
using .SpatialData

include("graphs.jl")
using .AxisIndicesGraphs

include("deprecations.jl")

@reexport using NamedIndicesMeta.TimeData

@reexport using NamedIndicesMeta.ColorData

@reexport using NamedIndicesMeta.ObservationData

@reexport using NamedIndicesMeta.SpatialData

@reexport using NamedIndicesMeta.AxisIndicesGraphs

end # module

