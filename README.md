# NamedIndicesMeta

[![Build Status](https://travis-ci.com/Tokazama/NamedIndicesMeta.jl.svg?branch=master)](https://travis-ci.com/Tokazama/NamedIndicesMeta.jl)
[![Codecov](https://codecov.io/gh/Tokazama/NamedIndicesMeta.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Tokazama/NamedIndicesMeta.jl)


## What is this

It's a veritable cornucopia of magical mini modules for binding custom indexing, named dimensions, and metadata to different structures in Julia.
For now it's not registered because most of the modules should be fleshed out into proper packages at some point.

## Dimension specific methods

## Relevant syntax

Syntax map
* `indices`: literal mapping to an arrays memory indices
* `keys`: representative keys relevant to a dimension. For example, a time dimension may have keys composed of seconds.
* `axis`: the axis that belongs to to a certain dimension. This may be the same as `indices` or be a subtype of `AbstractAxis`, including keys and indices together.
* `dim`: returns the dimension corresponding to a given dimension name.
* `units`: if appropriate returns a Unitful type

This provides a predictable syntax for users that want to consistently access a certain dimension.
For example, the following would be relevant to an array with a time dimension:
* `time_indices`: indices for the array corresponding to the time dimension (e.g., `Base.OneTo(10)` for an `Array` where the time dimension is ten elements in length).
* `time_keys`: time specific unites along the time dimension (e.g., `Second(1):Second(1):Second(10)` for ten seconds along the time dimension)
* `time_axis`: if using an `AxisIndicesArray` and the previous examples this could be `Axis(Second(1):Second(1):Second(10), Base.OneTo(10))`.
* `timedim`: if using a `NamedDimsArray` with the names `(:height, :width, :time)` then this would return 3.
* `time_units`: If instead of `Second` the Unitful representation `s` is used for seconds, then `s` will be returned.

## Formally defining a dimension

Producing the previously described time relevant methods involves two steps.

1. Create a method that identifies the `Symbol` corresponding to time, which in this case is `is_time(x::Symbol) = x === :time`
2. Generate the methods, `@defdim time is_time`

Note: The current method requires this `Base.@pure is_time(x::Symbol) = x === :time` for the `@defdim` macro to result in methods that are type inferable. 

## Moving Between Formats

TODO: need to document and test. beginnings are in "src/data_format.jl"

