
function AxisIndices.axes_type(::Type{<:NamedDimsArray{L,T,N,A}}) where {L,T,N,A}
    return AxisIndices.axes_type(A)
end

"""
    NIArray()
"""
const NIArray{names,T,N,P<:AbstractArray{T,N},Ax} = NamedDimsArray{names,T,N,AxisIndicesArray{T,N,P,Ax}}
NIArray(x::AbstractArray; kwaxes...) = NIArray(x, kwaxes.data)
function NIArray(x::AbstractArray, namedaxes::NamedTuple{L}) where {L}
    return NamedDimsArray{L}(AxisIndicesArray(x, values(namedaxes)))
end


"""
    IMArray()
"""
const IMArray{T,N,P<:AbstractArray{T,N},Ax,M} = AxisIndicesArray{T,N,ImageMeta{T,N,P,M},Ax}
IMArray(x::AbstractArray, args...; metadata=Metadata()) = IMArray(x, Tuple(args), metadata)
IMArray(x::AbstractArray, axs::Tuple, metadata) = AxisIndicesArray(ImageMeta(x, metadata), axs)

"""
    MetaArray

"""
const MetaArray{T,N,P<:AbstractArray{T,N},M<:AbstractMetadata} = ImageMeta{T,N,P,M}
MetaArray(x::AbstractArray, metadata=Metadata()) = ImageMeta(x, metadata)

"""
    NIMArray(x, args...; metadata, kwargs...)

Returns an array with named dimensions, an `AbstractAxis` for each indice, and metadata)
"""
const NIMArray{names,T,N,P<:AbstractArray{T,N},Ax,M} = NamedDimsArray{names,T,N,AxisIndicesArray{T,N,ImageMeta{T,N,P,M},Ax}}

function NIMArray(x::AbstractArray; metadata=Metadata(), kwaxes...)
    return NIMArray(x, kwaxes.data, metadata)
end

function NIMArray(x::AbstractArray, namedaxes::NamedTuple{L}, metadata) where {L}
    return NamedDimsArray{L}(IMArray(x, values(namedaxes), metadata))
end

function NIMArray(x::AbstractArray{T,N}, args...; metadata::AbstractDict{Symbol,Any}=Metadata(), kwargs...) where {T,N}
    if isempty(args)
        if isempty(kwargs)
            return _NIMArray(x, metadata)
        else
            return _NIMArray(x, values(kwargs), metadata)
        end
    elseif isempty(kwargs)
        return _NIMArray(x, args, metadata)
    else
        error("Indices can only be specified by keywords or additional arguments after the parent array, not both.")
    end
end

function _NIMArray(x::AbstractArray{T,N}, namedindices::NamedTuple{L}, metadata) where {T,N,L}
    return NamedDimsArray{L}(AxisIndicesArray(ImageMeta(x, metadata), values(namedindices)))
end

function _NIMArray(x::AbstractArray{T,N}, indices::Tuple, metadata) where {T,N,L}
    return NamedDimsArray{ntuple(_ -> :_, Val(N))}(AxisIndicesArray(ImageMeta(x, metadata), indices))
end

function _NIMArray(x::AbstractArray{T,N}, metadata) where {T,N,L}
    return NamedDimsArray{ntuple(_ -> :_, Val(N))}(AxisIndicesArray(ImageMeta(x, metadata)))
end

function _NIMArray(x::AbstractArray{T,N}, axs::Tuple{Vararg{Symbol}}, metadata) where {T,N}
    return NamedDimsArray{axs}(AxisIndicesArray(ImageMeta(x, metadata)))
end

const NamedMappedArray{L,T,N,A,F} = Union{<:ReadonlyMappedArray{T,N,NamedDimsArray{L,T,N,A},F},<:MappedArray{T,N,NamedDimsArray{L,T,N,A},F}}

NamedDims.dimnames(::Type{<:NamedMappedArray{L,T,N,A,F}}) where {L,T,N,A,F} = L
function AxisIndices.axes_type(::Type{<:NamedMappedArray{L,T,N,A,F}}) where {L,T,N,A,F}
    return AxisIndices.axes_type(A)
end

@inline function Base.axes(nma::NamedMappedArray{L,T,N,A,F}, i::Symbol) where {L,T,N,A,F}
    return axes(parent(nma), dim(L, i))
end

# TODO move to DimNames
@inline named_axes(x::X) where {X} = NamedTuple{dimnames(X)}(axes(x))

