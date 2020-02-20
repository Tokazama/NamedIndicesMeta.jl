
has_time_axis(x) = Base.sym_in(:time, dimnames(x))

ImageAxes.timedim(nda::NamedDimsArray) = NamedDims.dim_noerror(dimnames(nda), :time)

function ImageAxes.timeaxis(nda::NamedDimsArray)
    d = NamedDims.dim_noerror(dimnames(nda), :time)
    if d === 0
        return nothing
    else
        return keys(axes(nda, :time))
    end
end

has_color_axis(x) = Base.sym_in(:color, dimnames(x))

ImageAxes.colordim(nda::NamedDimsArray) = NamedDims.dim_noerror(dimnames(nda), :color)

