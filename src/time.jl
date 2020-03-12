
module TimeData

using ImageCore, AxisIndices, NamedDims, NamedIndicesMeta
import ImageAxes
import ImageAxes: timedim, timeaxis

export
    TimeAxis,
    # @defdim output
    is_time,
    timedim,
    has_timedim,
    time_axis,
    time_axis_type,
    time_keys,
    time_indices,
    to_time_format,
    time_format,
    ntime,
    nimages,
    # other methods
    time_end,
    onset,
    duration,
    sampling_rate,
    assert_timedim_last

Base.@pure is_time(x::Symbol) = x === :time

@defdim time is_time

"""
    time_end(x)

Last time point along the time axis.
"""
time_end(x) = last(time_axis(x))

"""
    onset(x)

First time point along the time axis.
"""
onset(x) = first(time_axis(x))

"""
    duration(x)

Duration of the event along the time axis.
"""
duration(x) =  - onset(x)

"""
    sampling_rate(x)

Number of samples per second.
"""
sampling_rate(x) = 1/step(time_axis(x))

function ImageCore.nimages(x::NamedDimsArray)
    d = NamedDims.dim_noerror(dimnames(x), :time)
    if d === 0
        return 1
    else
        return size(x, d)
    end
end

function ImageCore.assert_timedim_last(img::NamedDimsArray{L}) where {L}
    last(L) === :time || error("time dimension is not last")
    return nothing
end

struct TimeAxis{K,V,Ks,Vs} <: AbstractAxis{K,V,Ks,Vs}
    axis::Axis{K,V,Ks,Vs}
    times::Dict{Symbol,Pair{K,K}}

    function TimeAxis{K,V,Ks,Vs}(axis::Axis{K,V,Ks,Vs}, times::Dict{Symbol,Pair{K,K}}) where {K,V,Ks,Vs}
        return new{K,V,Ks,Vs}(axis, times)
    end

    function TimeAxis{K,V,Ks,Vs}(args...; kwargs...) where {K,V,Ks,Vs}
       d = Dict{Symbol,Pair{K,K}}()
       for (k,v) in kwargs
           d[k] = v
       end
       return new{K,V,Ks,Vs}(Axis{K,V,Ks,Vs}(args...), d)
    end

    function TimeAxis(args...; kwargs...)
        ax = Axis(args...)
        d = Dict{Symbol,Pair{keytype(ax),keytype(ax)}}()
        for (k,v) in kwargs
            d[k] = v
        end
        return new{keytype(ax),valtype(ax),keys_type(ax),values_type(ax)}(ax, d)
    end
end

Base.keys(t::TimeAxis) = keys(getfield(t, :axis))
Base.values(t::TimeAxis) = values(getfield(t, :axis))
function AxisIndices.similar_type(
    t::TimeAxis{K,V,Ks,Vs},
    new_keys_type::Type=Ks,
    new_values_type::Type=Vs
    ) where {K,V,Ks,Vs}
    return TimeAxis{eltype(new_keys_type),eltype(new_values_type),new_keys_type,new_values_type}
end

Base.setindex!(t::TimeAxis, val, i::Symbol) = t.times[i] = val

function Base.to_index(t::TimeAxis, i::Symbol)
   f, l = t.times[i]
   return Base.to_index(t, and(>=(f), <=(l)))
end

end

