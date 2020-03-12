
module AxisIndicesGraphs

using AxisIndices, LightGraphs, SimpleWeightedGraphs
using Base: to_index, @propagate_inbounds


struct AxisIndicesGraph{T,G<:AbstractGraph{T},AI} <: AbstractGraph{T}
    graph::G
    axes::AI
end

Base.parent(g::AxisIndicesGraph) = getfield(g, :graph)

# Although it seems weird to overload this for graphs it makes sense in the context
# of how an "axis" is defined (e.g., keys + indices)
Base.axes(g::AxisIndicesGraph) = getfield(g, :axes)

# Shouldn't these be performed on the type
#eltype(g::AbstractMetaGraph) = eltype(g.graph)
#edgetype(g::AbstractMetaGraph) = edgetype(g.graph)

###
### Vertices
###
LightGraphs.nv(g::AxisIndicesGraph) = nv(parent(g))
LightGraphs.vertices(g::AxisIndicesGraph) = vertices(parent(g))

LightGraphs.has_vertex(g::AxisIndicesGraph, x...) = has_vertex(parent(g), x...)
@inline LightGraphs.has_edge(g::AxisIndicesGraph, x...) = has_edge(parent(g), x...)

@propagate_inbounds function LightGraphs.add_vertex!(g::AxisIndicesGraph, u, v,)
    return add_vertex!(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end

@propagate_inbounds function LightGraphs.rem_vertex!(g::AxisIndicesGraph, u, v)
    return rem_vertex!(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end

###
### Edges
###
LightGraphs.ne(g::AxisIndicesGraph) = ne(parent(g))
LightGraphs.edges(g::AxisIndicesGraph) = edges(parent(g))

@propagate_inbounds function LightGraphs.add_edge!(g::AxisIndicesGraph, u, v)
    return add_edge!(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end
@propagate_inbounds function LightGraphs.add_edge!(g::AxisIndicesGraph, u, v, val)
    return add_edge!(parent(g), to_index(axes(g), u), to_index(axes(g), v), val)
end

@propagate_inbounds function LightGraphs.rem_edge!(g::AxisIndicesGraph, u, v)
    return rem_edge!(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end


function LightGraphs.inneighbors(g::AxisIndicesGraph, v)
    return inneighbors(parent(g), to_index(axes(g), v))
end
function LightGraphs.outneighbors(g::AxisIndicesGraph, v)
    return outneighbors(parent(g), to_index(axes(g), v))
end

Base.Base.issubset(g::AxisIndicesGraph, h::AbstractGraph) = issubset(parent(g), h)


LightGraphs.is_directed(::Type{<:AxisIndicesGraph{T,G}}) where {T,G} = is_directed(G)

SimpleWeightedGraphs.weighttype(::Type{<:AxisIndicesGraph{T,G}}) where {T,G} = weighttype(G)

# TODO these should be AxisIndicesArrays
SimpleWeightedGraphs.degree_matrix(g::AxisIndicesGraph, args...) = degree_matrix(parent(g), args...)
function LightGraphs.adjacency_matrix(g::AxisIndicesGraph, args...)
    return adjacency_matrix(parent(g), args...)
end

function LightGraphs.laplacian_matrix(g::AxisIndicesGraph, args...)
    return laplacian_matrix(parent(g), args...)
end

function LightGraphs.pagerank(g::AxisIndicesGraph, α=0.85, n::Integer=100, ϵ=1.0e-6)
    return pagerank(parent(g), α, n, ϵ)
end

function SimpleWeightedGraphs.get_weight(g::AxisIndicesGraph, u, v)
    return get_weight(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end

LightGraphs.connected_components(g::AxisIndicesGraph) = connected_components(parent(g))

function LightGraphs.induced_subgraph(g::AxisIndicesGraph, vlist)
    return induced_subgraph(parent(g), to_index(axes(g), vlist))
end

###
### Base
###
Base.zero(g::AxisIndicesGraph) = AxisIndicesGraph(zero(parent(g)), axes(g))

Base.copy(g::AxisIndicesGraph) = AxisIndicesGraph(copy(parent(g)), copy(axes(g)))

end
