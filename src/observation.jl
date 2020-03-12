
module ObservationData

using ImageCore, ImageAxes, AxisIndices, NamedIndicesMeta

export
    # @defdim output
    obsdim,
    has_obsdim,
    obs_axis,
    obs_axis_type,
    obs_keys,
    obs_indices,
    to_obs_format,
    nobs,
    obs_format,
    is_observation
 
Base.@pure is_observation(x::Symbol) = (x === :obs) | (x === :observations) | (x === :samples)

@defdim obs is_observation

end

