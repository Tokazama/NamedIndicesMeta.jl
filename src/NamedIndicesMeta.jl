module NamedIndicesMeta

using NamedDims, ImageCore, ImageMetadata, ImageAxes, FieldProperties, AxisIndices
using Base: tail

import ImageAxes: timeaxis, timedim, colordim

export
    NIMArray,
    NIArray,
    IMArray,
    MetaArray,
    # reexports
    properties,
    # color
    colordim,
    has_color_axis,
    indices_color,
    coloraxis,
    # frequency
    frequencydim,
    has_frequency_axis,
    indices_frequency,
    frequencyaxis,
    # channel
    channeldim,
    has_channel_axis,
    indices_channel,
    channelaxis,
    # observation
    observationdim,
    has_observation_axis,
    indices_observation,
    observationaxis,
    # time
    has_time_axis,
    timedim,
    timeaxis,
    nimages,
    time_end,
    onset,
    duration,
    sampling_rate,
    # spatial
    spatial_axes,
    spacedirections,
    coords_spatial,
    indices_spatial,
    pixelspacing

include("types.jl")
include("named_dimensions.jl")
include("spatial.jl")
include("time.jl")
include("channels.jl")
include("properties.jl")

end # module

