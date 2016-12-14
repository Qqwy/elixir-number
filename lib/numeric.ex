defmodule Numeric do
  @moduledoc """
  Any module that wants to be a Numeric type,
  and to be able to be called by the functions in Number,
  should make sure that this behaviour is followed.

  Your callbacks will only ever be called with two versions of your Numeric struct.
  If one of the functions in Number is called with one of the arguments being an integer or float,
  then it is first converted to your Numeric struct by calling `YourStructModule.new(the_int_or_float)` on it.
  """

  @typedoc "numericStruct should be a struct that follows the Numeric behaviour."
  @type numericStruct :: struct

  @typedoc """
  To be used in your typespecs at any place where a Numeric type can be used.
  """
  @type t :: number | numericStruct

  @doc """
  Creates a new numericStruct from the given built-in integer or float.

  In the case of reading a float, it is okay to lose precision.

  This callback is optional, because there are data types for which this conversion
  is impossible or ambiguous.
  """
  @callback new(integer | float) :: numericStruct
  @optional_callbacks new: 1

  @doc """
  Adds two numbers together.
  """
  @callback add(numericStruct, numericStruct) :: numericStruct

  @doc """
  Subtracts the rhs number from the lhs number.
  """
  @callback sub(numericStruct, numericStruct) :: numericStruct

  @doc """
  Multiplies the two numbers together.
  """
  @callback mult(numericStruct, numericStruct) :: numericStruct

  @doc """
  Divides the rhs by the lhs.

  To be clear, this division operation is supposed to keep precision.
  """
  @callback div(numericStruct, numericStruct) :: numericStruct

  @doc """
  Unary minus. Should return the negation of the number.
  """
  @callback minus(numericStruct) :: numericStruct

  @doc """
  The absolute value of a number.
  """
  @callback abs(numericStruct) :: numericStruct

  @doc """
  Convert the custom Numeric struct
  to the built-in float datatype.

  It is okay to lose precision during this conversion.

  This function is optional, because there are many numeric types
  that cannot be (unambiguously) converted into a floating-point number.
  """
  @callback to_float(numericStruct) :: float
  @optional_callbacks to_float: 1

  @doc """
  Power function, x^n.

  When this optional function is not provided, `Number` will use the 'Exponentiation by Squaring'
  algorithm to calculate the result (which uses log(n) repeated multiplications).

  Add it to your data type if it is possible to compute a power using a faster algorithm.
  """
  @callback pow(numericStruct, integer) :: numericStruct

  @optional_callbacks pow: 2

end
