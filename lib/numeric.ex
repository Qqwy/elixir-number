defmodule Numeric do
  @moduledoc """
  Any module that wants to be a Numeric type,
  and to be able to be called by the functions in Number,
  should make sure that this behaviour is followed.
  """

  @doc "numStruct should be a struct that follows the Numeric behaviour."
  @type numStruct :: struct

  @doc """
  Creates a new numStruct from the given built-in integer or float.

  In the case of reading a float, it is okay to lose precision.
  """
  @callback new(integer | float) :: numStruct

  @doc """
  Adds two numbers together.
  """
  @callback add(number, numStruct) :: numStruct
  @callback add(numStruct, number) :: numStruct
  @callback add(numStruct, numStruct) :: numStruct

  @doc """
  Subtracts the rhs number from the lhs number.
  """
  @callback sub(number, numStruct) :: numStruct
  @callback sub(numStruct, number) :: numStruct
  @callback sub(numStruct, numStruct) :: numStruct

  @doc """
  Multiplies the two numbers together.
  """
  @callback mul(number, numStruct) :: numStruct
  @callback mul(numStruct, number) :: numStruct
  @callback mul(numStruct, numStruct) :: numStruct

  @doc """
  Divides the rhs by the lhs.

  To be clear, this division operation is supposed to keep precision.
  """
  @callback div(number, numStruct) :: numStruct
  @callback div(numStruct, number) :: numStruct
  @callback div(numStruct, numStruct) :: numStruct

  @doc """
  Unary minus. Should return the negation of the number.
  """
  @callback minus(numStruct) :: numStruct

  @doc """
  The absolute value of a number.
  """
  @callback abs(numStruct) :: numStruct

  @doc """
  Convert the custom Numeric struct
  to the built-in float datatype.

  It is okay to lose precision during this conversion.
  """
  @callback to_float(numStruct) :: float

  @doc """
  Power function, x^n.

  When this optional function is not provided, `Number` will use the 'Exponentiation by Squaring'
  algorithm to calculate the result (which uses log(n) repeated multiplications).

  Add it to your data type if it is possible to compute a power using a faster algorithm.
  """
  @callback pow(numStruct, integer) :: numStruct

  @optional_callbacks pow: 2

end
