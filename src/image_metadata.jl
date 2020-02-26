

# These should either reach ImageMeta or error
# Could use HasProperties to gracefully error though
ImageMetadata.properties(x::AxisIndicesArray) = properties(parent(x))
ImageMetadata.properties(x::NamedDimsArray) = properties(parent(x))

Base.hasproperty(x::IMArray, s::Symbol) = hasproperty(parent(x), s)
Base.hasproperty(x::NIMArray, s::Symbol) = hasproperty(parent(x), s)
Base.hasproperty(x::MetaArray, s::Symbol) = hasproperty(properties(x), s)

Base.getproperty(x::IMArray, s::Symbol) = getproperty(parent(x), s)
Base.getproperty(x::NIMArray, s::Symbol) = getproperty(parent(x), s)
Base.getproperty(x::MetaArray, s::Symbol) = getproperty(properties(x), s)

Base.setproperty!(x::IMArray, s::Symbol, val) = setproperty!(parent(x), s, val)
Base.setproperty!(x::NIMArray, s::Symbol, val) = setproperty!(parent(x), s, val)
Base.setproperty!(x::MetaArray, s::Symbol, val) = setproperty!(properties(x), s, val)

