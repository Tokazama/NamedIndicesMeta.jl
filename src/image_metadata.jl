

# These should either reach ImageMeta or error
# Could use HasProperties to gracefully error though
ImageMetadata.properties(x::AxisIndicesArray) = properties(parent(x))
ImageMetadata.properties(x::NamedDimsArray) = properties(parent(x))

Base.hasproperty(x::IMArray, s) = hasproperty(parent(x), s)
Base.hasproperty(x::NIMArray, s) = hasproperty(parent(x), s)
Base.hasproperty(x::MetaArray) = hasproperty(properties(x), s)

Base.getproperty(x::IMArray, s) = getproperty(parent(x), s)
Base.getproperty(x::NIMArray, s) = getproperty(parent(x), s)
Base.getproperty(x::MetaArray, s) = getproperty(properties(x), s)

Base.setproperty!(x::IMArray, s, val) = setproperty!(parent(x), s, val)
Base.setproperty!(x::NIMArray, s, val) = setproperty!(parent(x), s, val)
Base.setproperty!(x::MetaArray, s, val) = setproperty!(properties(x), s, val)

