
for name in (:time, :color, :frequency, :channel, :observation)

    has_name_axis = Symbol(:has_, name, :_axis)
    has_name_axis_docs = """
        $has_name_axis(x) -> Bool

    Returns `true` if `x` has an axis for $name.
    """
    @eval begin
        @doc $has_name_axis_docs
        $has_name_axis(x) = Base.sym_in($(QuoteNode(name)), dimnames(x))
    end

    namedim = Symbol(name, :dim)
    namedim_doc = """
        $namedim(x) -> Int

    Return the dimension of the array used for $name time.
    """
    @eval begin
        @doc $namedim_doc
        $namedim(x::NamedDimsArray) = NamedDims.dim_noerror(dimnames(x), $(QuoteNode(name)))
    end

    name_axis = Symbol(name, :axis)
    name_axis_doc = """
        $name_axis(x)

    Returns the axis corresponding to the $name dimension (e.g., `keys(axes(x, $namedim(x)))`).
    """
    @eval begin
        @doc $name_axis_doc
        function $name_axis(x::NamedDimsArray)
            d = $namedim(x)
            if d === 0
                return nothing
            else
                return keys(axes(x, d))
            end
        end
    end

    name_indices = Symbol(:indices_, name)
    name_indices_doc = """
        $name_indices(x)

    Returns the indices corresponding to the $name dimension.
    """
    @eval begin
        @doc $name_indices_doc
        function $name_indices(x)
            d = $namedim(x)
            if d === 0
                return nothing
            else
                return values(axes(x, d))
            end
        end
    end
end

