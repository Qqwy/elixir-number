defmodule Number do

  import Kernel, except: [div: 2]

  @moduledoc """
  Exposes helper functions to perform math on numbers which might be
  custom data types.
  This allows Compex Numbers to be built on any kind of numeric class.

  Math with custom data types is supported, as long as:

  1) One or both of the operands are of the type structModule. The arguments are passed to `structModule` as-is:
     if `structModule` supports addition, subtraction, etc. with one of the numbers being a built-in number (e.g. Integer or Float), then this is also supported by the MathHelper.
  2) This `structModule` module exposes the arity-2 functions `add`, `sub`, `mul`, `div` to do addition, subtraction, multiplication and division, respectively.
  3) This `structModule` exposes the arity-1 function `minus` to negate a number and `abs` to change a number to its absolute value.


  Note that `div` is supposed to be precise division (i.e. no rounding should be performed).
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
      numericType.unquote(name)(a, b)
    end

    #num + struct
    def unquote(name)(a, b = %numericType{}) when is_number(a) do
      numericType.unquote(name)(a, b)
    end

    # struct + struct
    def unquote(name)(a = %numericType{}, b = %numericType{}) do
      numericType.unquote(name)(a, b)
    end

  end

  def minus(num = %numericType{}), do: numericType.minus(num)
  def minus(num) when is_number(num), do: Kernel.-(num)


  def abs(num = %numericType{}), do: numericType.abs(num)
  def abs(num) when is_number(num), do: Kernel.abs(num)


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
