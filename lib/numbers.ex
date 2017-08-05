defmodule Numbers do
  import Kernel, except: [div: 2]

  @type t :: any

  @doc """
  Adds two Numeric `a` and `b` together.

  Depends on an implementation existing of `Numbers.Protocol.Addition`
  """
  @spec add(t, t) :: t
  def add(a, b) do
    {a, b} = Coerce.coerce(a, b)
    Numbers.Protocols.Addition.add(a, b)
  end

  defdelegate add_id(num), to: Numbers.Protocols.Addition

  @doc """
  Subtracts the Numeric `b` from the Numeric `a`.

  Depends on an implementation existing of `Numbers.Protocol.Subtraction`
  """
  @spec sub(t, t) :: t
  def sub(a, b) do
    {a, b} = Coerce.coerce(a, b)
    Numbers.Protocols.Subtraction.sub(a, b)
  end

  @doc """
  Multiplies the Numeric `a` with the Numeric `b`

  Depends on an implementation existing of `Numbers.Protocol.Multiplication`
  """
  @spec mult(t, t) :: t
  def mult(a, b) do
    {a, b} = Coerce.coerce(a, b)
    Numbers.Protocols.Multiplication.mult(a, b)
  end

  defdelegate mult_id(num), to: Numbers.Protocols.Multiplication

  @doc """
  Divides the Numeric `a` by `b`.

  Note that this is a supposed to be a full (non-truncated) division;
  no rounding or truncation is supposed to happen, even when calculating with integers.

  Depends on an implementation existing of `Numbers.Protocol.Division`
  """
  @spec div(t, t) :: t
  def div(a, b) do
    {a, b} = Coerce.coerce(a, b)
    Numbers.Protocols.Division.div(a, b)
  end
  @doc """
  Power function: computes `base^exponent`,
  where `base` is Numeric,
  and `exponent` _has_ to be an integer.

  _(This means that it is impossible to calculate roots by using this function.)_

  Depends on an implementation existing of `Numbers.Protocol.Exponentiation`
  """
  @spec pow(t, non_neg_integer) :: t
  def pow(a, b) do
    {a, b} = Coerce.coerce(a, b)
    Numbers.Protocols.Exponentiation.pow(a, b)
  end

  @doc """
  Unary minus. Returns the negation of the number.

  Depends on an implementation existing of `Numbers.Protocols.Minus`
  """
  @spec minus(t) :: t
  defdelegate minus(num), to: Numbers.Protocols.Minus


  @doc """
  The absolute value of a number.

  Depends on an implementation existing of `Numbers.Protocols.Absolute`
  """
  @spec abs(t) :: t
  defdelegate abs(num), to: Numbers.Protocols.Absolute

  @doc """
  Convert the custom Numeric struct
  to the built-in float datatype.

  This operation might be lossy, losing precision in the process.
  """
  @spec to_float(t) :: {:ok, t_as_float :: float} | :error
  defdelegate to_float(num), to: Numbers.Protocols.ToFloat
end
