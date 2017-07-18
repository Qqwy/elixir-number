defmodule Numbers.Numeric do
  @moduledoc """
  Any module that wants to be a Numeric type,
  and to be able to be called by the functions in Number,
  should make sure that this behaviour is followed.

  Your callbacks will only ever be called with two versions of your Numeric struct.
  If one of the functions in Number is called with one of the arguments being an integer or float,
  then it is first converted to your Numeric struct by calling `YourStructModule.new(the_int_or_float)` on it.
  """

  @typedoc "numeric_struct should be a struct that follows the Numeric behaviour."
  @type numeric_struct :: struct

  @typedoc """
  To be used in your typespecs at any place where a Numeric type can be used.
  """
  @type t :: number | numeric_struct

  @doc """
  Creates a new numeric_struct from the given built-in integer or float.

  In the case of reading a float, it is okay to lose precision.

  This callback is optional, because there are data types for which this conversion
  is impossible or ambiguous.

  If more control is needed over the creation of a datatype from a built-in type,
  or coercion between two custom data types, implement `coerce/2` instead.
  """
  @callback new(any) :: numeric_struct
  @optional_callbacks new: 1

  @doc """
  `coerce/2` will be called by Numbers if the parameters are not of the same type:

  - If one of the parameters is an Integer, Float or other built-in datatype, `coerce/2` is called on the struct module of the other parameter.
  - If struct module does not have a `coerce/2` method, `new/1` is called instead, with the builtin datatype as argument.
  - If both of the parameters are structs, `coerce/2` is called on the left-hand-side argument's struct module.
  - If the left-hand-side argument's struct module does not expose a `coerce/2` method, Numbers will call `coerce/2` on the right-hand-side argument's struct module.
  - If the right-hand-side argument _also_ does not expose a `coerce/2` method, a Numbers.AmbiguousOperandsError is raised.

  In all of these cases, the positions of the parameters is kept the same.

  The return value of `coerce/2` should be a tuple where the 'foreign' type
  is coerced into the type of the other, in the same order as the input paremeters were specified.

  ## Some Examples

  Say Numbers wants to perform addition, `N.add(%Foo{bar: 42}, )`.
  `1` is a built-in Integer, so Numbers will try to call `Foo.coerce(%Foo{bar: 42}, 1)`
  This returns a tuple of the coerced arguments in the same order. For instance: `{%Foo{bar: 42}, %Foo{bar: 1}}`

  Now, Numbers dispatches the addition call as `Foo.add(%Foo{bar: 42}, %Foo{bar: 1})`.


  ### Another Example

  Say the module `Bar` does not have a `coerce/2` defined, (But the module `Foo` does):

  `N.sub(%Bar{qux: 3.1}, %Foo{bar: 1234})` will try to call `Bar.coerce(%Bar{qux: 3.1}, %Foo{bar: 1234})`,
  but as this function does not exist, it will instead call `Foo.coerce(%Bar{qux: 3.1}, %Foo{bar: 1234})`.
  """
  @callback coerce(numeric_struct, t) :: {numeric_struct, numeric_struct}
  @callback coerce(t, numeric_struct) :: {numeric_struct, numeric_struct}
  @optional_callbacks coerce: 2

  @doc """
  Adds two numbers together.
  """
  @callback add(numeric_struct, numeric_struct) :: numeric_struct

  @doc """
  Subtracts the rhs number from the lhs number.
  """
  @callback sub(numeric_struct, numeric_struct) :: numeric_struct

  @doc """
  Multiplies the two numbers together.
  """
  @callback mult(numeric_struct, numeric_struct) :: numeric_struct

  @doc """
  Divides the rhs by the lhs.

  To be clear, this division operation is supposed to keep precision.
  """
  @callback div(numeric_struct, numeric_struct) :: numeric_struct

  @doc """
  Unary minus. Should return the negation of the number.
  """
  @callback minus(numeric_struct) :: numeric_struct

  @doc """
  The absolute value of a number.
  """
  @callback abs(numeric_struct) :: numeric_struct

  @doc """
  Convert the custom Numeric struct
  to the built-in float datatype.

  It is okay to lose precision during this conversion.

  This function is optional, because there are many numeric types
  that cannot be (unambiguously) converted into a floating-point number.
  """
  @callback to_float(numeric_struct) :: float
  @optional_callbacks to_float: 1

  @doc """
  Power function, x^n.

  When this optional function is not provided, `Number` will use the 'Exponentiation by Squaring'
  algorithm to calculate the result (which uses log(n) repeated multiplications).

  Add it to your data type if it is possible to compute a power using a faster algorithm.
  """
  @callback pow(numeric_struct, integer) :: numeric_struct

  @optional_callbacks pow: 2
end
