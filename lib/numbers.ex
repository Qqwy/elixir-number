defmodule Numbers do

  import Kernel, except: [div: 2]

  @moduledoc """
  Allows you to perform math on any kind of data structure that follows the Numeric behaviour.

  This includes plain Integer and Floats, but also many custom numeric types specified in packages
  (such as Ratio, Decimal, Tensor, ComplexNum).

 """

  # Attempt to add two real numbers together.
  # Does not make assumptions on the types of A and B.
  # As long as they are the same kind of struct, will call structModule.add(a, b).
  # Will use Kernel.+(a, b) for built-in numeric types.
  # defp real_add(a, b)

  # defp real_add(a, b) when is_number(a) and is_number(b) do
  #   Kernel.+(a, b)
  # end

  # defp real_add(a = %numericType{}, b = %numericType{}) do
  #   numericType.add(a, b)
  # end

  # defp real_add(a = %numericType{}, b) when is_number(b) do
  #   numericType.add(a, b)
  # end


  # defp real_add(a, b = %numericType{}) when is_number(a) do
  #   numericType.add(a, b)
  # end

  binary_operations = [add: &+/2, sub: &-/2, mul: &*/2, div: &//2]

  for {name, kernelFun} <- binary_operations do
    # num + num
    def unquote(name)(a, b) when is_number(a) and is_number(b) do
      unquote(kernelFun).(a, b)
    end

    # struct + num
    def unquote(name)(a = %numericType{}, b) when is_number(b) do
      numericType.unquote(name)(a, numericType.new(b))
    end

    #num + struct
    def unquote(name)(a, b = %numericType{}) when is_number(a) do
      numericType.unquote(name)(numericType.new(a), b)
    end

    # struct + struct
    def unquote(name)(a = %numericType{}, b = %numericType{}) do
      numericType.unquote(name)(a, b)
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
      raise CannotConvertToFloatError, message: "#{num} cannot be converted to a Float."
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
  defp pow_by_sq(x, 2), do: mul(x, x)
  defp pow_by_sq(x, 3), do: mul(mul(x, x), x)
  defp pow_by_sq(x, n) when is_integer(n), do: do_pow_by_sq(x, n)

  # Exponentiation By Squaring.
  defp do_pow_by_sq(x, n, y \\ 1)
  defp do_pow_by_sq(_x, 0, y), do: y
  defp do_pow_by_sq(x, 1, y), do: mul(x, y)
  defp do_pow_by_sq(x, n, y) when n < 0, do: do_pow_by_sq(div(1, x), Kernel.-(n), y)
  defp do_pow_by_sq(x, n, y) when rem(n, 2) == 0, do: do_pow_by_sq(mul(x, x), Kernel.div(n, 2), y)
  defp do_pow_by_sq(x, n, y), do: do_pow_by_sq(mul(x, x), Kernel.div((n - 1), 2), mul(x, y))
  
  


end
