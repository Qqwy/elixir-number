defmodule Numbers do

  import Kernel, except: [div: 2]

  @moduledoc """
  Allows you to perform math on any kind of data structure that follows the Numeric behaviour.

  This includes plain Integer and Floats, but also many custom numeric types specified in packages
  (such as Ratio, Decimal, Tensor, ComplexNum).

  """

  defmodule AmbiguousOperandsError do
    @moduledoc """
    Raised when add/2, sub/2, mult/2 or div/2 is called with two different kinds of structs as arguments.
    """
    defexception message: "Cannot perform arithmetic with two different kinds of operands.\n Convert them to the same types beforehand."
  end

  binary_operations = [add: &+/2, sub: &-/2, mult: &*/2, div: &//2]

  @doc """
  Adds two Numeric `a` and `b` together.
  """
  def add(a, b)

  @doc """
  Subtracts the Numeric `b` from the Numeric `a`.
  """
  def sub(a, b)

  @doc """
  Multiplies the Numeric `a` with the Numeric `b`
  """
  def mult(a, b)

  @doc """
  Divides the Numeric `a` by `b`.

  Note that this is a supposed to be a full (non-truncated) division;
  no rounding or truncation is supposed to happen, even when calculating with integers.
  """
  def div(a, b)

  for {name, kernelFun} <- binary_operations do
    # num + num
    def unquote(name)(a, b) when is_number(a) and is_number(b) do
      unquote(kernelFun).(a, b)
    end

    # struct + struct
    def unquote(name)(a = %numericType{}, b = %numericType{}) do
      numericType.unquote(name)(a, b)
    end

    # struct + otherStruct
    def unquote(name)(a = %_oneType{}, b = %_differentType{}) do
      raise AmbiguousOperandsError, message: "Cannot perform arithmetic with two different kinds of operands (#{inspect(a)} vs. #{inspect(b)}).\n Convert them to the same type beforehand."
    end

    # struct + builtin
    def unquote(name)(a = %numericType{}, b) do
      numericType.unquote(name)(a, coerce(numericType, b))
    end

    # builtin + struct
    def unquote(name)(a, b = %numericType{}) do
      numericType.unquote(name)(coerce(numericType, a), b)
    end

  end

  defmodule CannotCoerceError do
    @moduledoc """
    Raised by `coerce/2` when coercion is not possible.
    """
    defexception message: "Cannot convert the number to the specified type."
  end

  @doc """
  Attempts to coerce a built-in datatype `num` to a struct of type `numericType`
  by calling `numericType.new(num)`.

  This function will raise an `CannotCoerceError` if:

  - There is no `numericType.new/1` function available.
  - The function is available but returns an ArgumentError for the passed built-in data type.

  """
  def coerce(numericType, num) when is_atom(numericType) and is_number(num) do
    if Kernel.function_exported?(numericType, :new, 1) do
      try do
        numericType.new(num)
      rescue
        e in ArgumentError ->
          raise CannotCoerceError, message: """
          The coercion of #{inspect(num)} to #{numericType} failed for the following reason:
          #{e.message}
          Stacktrace:
          #{Exception.format_stacktrace}
          """
      end
    else
      raise CannotCoerceError, message: "#{inspect(num)} cannot be coerced to a #{numericType}."
    end
  end

  @doc """
  Computes the unary minus of `num`, also known as its negation.
  """
  def minus(num = %numericType{}), do: numericType.minus(num)
  def minus(num) when is_number(num), do: Kernel.-(num)

  @doc """
  Computes the absolute value of `num`.
  """
  def abs(num = %numericType{}), do: numericType.abs(num)
  def abs(num) when is_number(num), do: Kernel.abs(num)

  defmodule CannotConvertToFloatError do
    @doc """
    Raised by `to_float/1` when (lossy) conversion to float is not possible.
    """
    defexception message: "Cannot convert the specified datatype to a Float."
  end

  @doc """
  Tries to convert `num` to a built-in floating-point number.

  Note that precision might be lost during this conversion.

  Not all numeric data types support this conversion!
  A `CannotConvertToFloatError` is raised if this conversion is unsupported by the passed data type.
  """
  def to_float(num) when is_integer(num), do: num * 1.0
  def to_float(num) when is_float(num), do: num
  def to_float(num = %numericType{}) do
    if Kernel.function_exported?(numericType, :to_float, 1) do
      numericType.to_float(num)
    else
      raise CannotConvertToFloatError, message: "#{inspect(num)} cannot be converted to a Float."
    end
  end

  @doc """
  Power function: computes `base^exponent`,
  where `base` is Numeric,
  and `exponent` _has_ to be an integer.

  This means that it is impossible to calculate roots by using this function.

  If `base` supports direct computation of `pow`, that is used. Otherwise,
  the Exponentiation by Squaring algorithm is used.
  """
  def pow(base = %numericType{}, exponent) when is_integer(exponent) do
    if Kernel.function_exported?(numericType, :pow, 2) do
      numericType.pow(base, exponent)
    else
      # Euclidean algorithm.
      # Exponentiation by Squaring
      pow_by_sq(base, exponent)
    end
  end

  # Integer power
  def pow(base, exponent) when is_integer(base) and is_integer(exponent) do
    pow_by_sq(base, exponent)
  end

  # Floating point power, imprecise.
  def pow(base, exponent) when is_float(base) and is_integer(exponent) do
    :math.pow(base, exponent)
  end

  # Small powers
  defp pow_by_sq(x, 1), do: x
  defp pow_by_sq(x, 2), do: mult(x, x)
  defp pow_by_sq(x, 3), do: mult(mult(x, x), x)
  defp pow_by_sq(x, n) when is_integer(n), do: do_pow_by_sq(x, n)

  # Exponentiation By Squaring.
  defp do_pow_by_sq(x, n, y \\ 1)
  defp do_pow_by_sq(_x, 0, y), do: y
  defp do_pow_by_sq(x, 1, y), do: mult(x, y)
  defp do_pow_by_sq(x, n, y) when n < 0, do: do_pow_by_sq(div(1, x), Kernel.-(n), y)
  defp do_pow_by_sq(x, n, y) when rem(n, 2) == 0, do: do_pow_by_sq(mult(x, x), Kernel.div(n, 2), y)
  defp do_pow_by_sq(x, n, y), do: do_pow_by_sq(mult(x, x), Kernel.div((n - 1), 2), mult(x, y))
end
