ExUnit.start()


defmodule NumericPair do
  @moduledoc """
  A very simple implementation of a data type
  that follows the Numeric specification.

  Simply delegates everything to its two elements
  in a really naïve (but simple i.e. testable) way.
  """

  defstruct [:a, :b]

  @behaviour Numeric

  alias Numbers, as: N

  def new(a), do: new(a, a)
  def new(a, b), do: %__MODULE__{a: a, b: b}

  def add(x, y), do: new(N.add(x.a, y.a), N.add(x.b, y.b))
  def sub(x, y), do: new(N.sub(x.a, y.a), N.sub(x.b, y.b))
  def mult(x, y), do: new(N.mult(x.a, y.a), N.mult(x.b, y.b))
  def div(x, y), do: new(N.div(x.a, y.a), N.div(x.b, y.b))

  def abs(x), do: new(N.abs(x.a), N.abs(x.b))
  def minus(x), do: new(N.minus(x.a), N.minus(x.b))

  def to_float(x), do: N.to_float(N.add(x.a, x.b))
end



defmodule NumericPairWithoutCoercion do
  @moduledoc """
  A very simple implementation of a data type
  that follows the Numeric specification.

  Simply delegates everything to its two elements
  in a really naïve (but simple i.e. testable) way.
  """

  defstruct [:a, :b]

  @behaviour Numeric

  alias Numbers, as: N

  def new(a, b), do: %__MODULE__{a: a, b: b}

  def add(x, y), do: new(N.add(x.a, y.a), N.add(x.b, y.b))
  def sub(x, y), do: new(N.sub(x.a, y.a), N.sub(x.b, y.b))
  def mult(x, y), do: new(N.mult(x.a, y.a), N.mult(x.b, y.b))
  def div(x, y), do: new(N.div(x.a, y.a), N.div(x.b, y.b))

  def abs(x), do: new(N.abs(x.a), N.abs(x.b))
  def minus(x), do: new(N.minus(x.a), N.minus(x.b))
end
