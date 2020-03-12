
abstract type DataFormat end

struct IteratorFormat end

struct ArrayFormat{D} end

###
function get_format(x::AbstractArray, condition, default=getdim_error)
    return getdim(x, condition, default)
end


to_format(::IteratorFormat, ::IteratorFormat, data) = data

# TODO
#function to_format(::ArrayFormat{D_dst}, src::IteratorFormat, data) where {D_dst}
#    return eachslice(data; dims=D_src)
#end

function to_format(::IteratorFormat, src::ArrayFormat{D_src}, data) where {D_src}
    return eachslice(data; dims=D_src)
end

to_format(::ArrayFormat{D}, ::ArrayFormat{D}, data) where {D} = data

function to_format(::ArrayFormat{D_dst}, ::ArrayFormat{D_src}, data::A) where {D_dst,D_src,A}
    perm = ntuple(ndims(A)) do ii
        if ii === D_dst
            return D_src
        elseif ii === D_src
            return D_dst
        else
            return ii
        end
    end
    return PermutedDimsArray(data, perm)
end

function to_format(dst, src, condition, default=getdim_error)
    return to_format(get_format(dst, condition, default),
                     get_format(src, condition, default),
                     src)
end

