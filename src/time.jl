
"""
    time_end(x)

Last time point along the time axis.
"""
time_end(x) = last(timeaxis(x))

"""
    onset(x)

First time point along the time axis.
"""
onset(x) = first(timeaxis(x))

"""
    duration(x)

Duration of the event along the time axis.
"""
duration(x) = stop_time(x) - onset(x)

"""
    sampling_rate(x)

Number of samples per second.
"""
sampling_rate(x) = 1/step(timeaxis(x))

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
    nothing
end
