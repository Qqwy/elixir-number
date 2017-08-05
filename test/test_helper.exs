ExUnit.start()


defmodule NumericPair do
  @moduledoc """
  A very simple implementation of a data type
  that follows the Numeric specification.

  Simply delegates everything to its two elements
  in a really naïve (but simple i.e. testable) way.
  """

  defstruct [:a, :b]

  # @behaviour Numbers.Numeric

  alias Numbers, as: N

  def new(a), do: new(a, a)
  def new(a, b), do: %__MODULE__{a: a, b: b}

  defimpl Numbers.Protocols.Addition do
    def add(x, y), do: @for.new(N.add(x.a, y.a), N.add(x.b, y.b))
    def add_id(num), do: @for.new(N.add_id(num.a), N.add_id(num.b))
  end

  defimpl Numbers.Protocols.Subtraction do
    def sub(x, y), do: @for.new(N.sub(x.a, y.a), N.sub(x.b, y.b))
  end

  defimpl Numbers.Protocols.Multiplication do
    def mult(x, y), do: @for.new(N.mult(x.a, y.a), N.mult(x.b, y.b))
    def mult_id(num), do: @for.new(N.mult_id(num.a), N.mult_id(num.b))
  end

  defimpl Numbers.Protocols.Division do
    def div(x, y), do: @for.new(N.div(x.a, y.a), N.div(x.b, y.b))
  end

  defimpl Numbers.Protocols.Absolute do
    def abs(x), do: @for.new(N.abs(x.a), N.abs(x.b))
  end

  defimpl Numbers.Protocols.Minus do
    def minus(x), do: @for.new(N.minus(x.a), N.minus(x.b))
  end

  defimpl Numbers.Protocols.ToFloat do
    def to_float(x), do: N.to_float(N.add(x.a, x.b))
  end
end

require Coerce
Coerce.defcoercion(NumericPair, Integer) do
  def coerce(numeric_pair, int) do
    {numeric_pair, NumericPair.new(int, int)}
  end
end
Coerce.defcoercion(NumericPair, Float) do
  def coerce(numeric_pair, float) do
    {numeric_pair, NumericPair.new(float, float)}
  end
end


defmodule NumericPairWithoutCoercion do
  @moduledoc """
  A very simple implementation of a data type
  that follows the Numeric specification.

  Simply delegates everything to its two elements
  in a really naïve (but simple i.e. testable) way.
  """

  defstruct [:a, :b]

  # @behaviour Numeric

  alias Numbers, as: N

  def new(a, b), do: %__MODULE__{a: a, b: b}

  defimpl Numbers.Protocols.Addition do
    def add(x, y), do: @for.new(N.add(x.a, y.a), N.add(x.b, y.b))
    def add_id(num), do: @for.new(N.add_id(num.a), N.add_id(num.b))
  end

  defimpl Numbers.Protocols.Subtraction do
    def sub(x, y), do: @for.new(N.sub(x.a, y.a), N.sub(x.b, y.b))
  end

  defimpl Numbers.Protocols.Multiplication do
    def mult(x, y), do: @for.new(N.mult(x.a, y.a), N.mult(x.b, y.b))
    def mult_id(num), do: @for.new(N.mult_id(num.a), N.mult_id(num.b))
  end

  defimpl Numbers.Protocols.Division do
    def div(x, y), do: @for.new(N.div(x.a, y.a), N.div(x.b, y.b))
  end

  defimpl Numbers.Protocols.Absolute do
    def abs(x), do: @for.new(N.abs(x.a), N.abs(x.b))
  end

  defimpl Numbers.Protocols.Minus do
    def minus(x), do: @for.new(N.minus(x.a), N.minus(x.b))
  end

  defimpl Numbers.Protocols.ToFloat do
    def to_float(x), do: N.to_float(N.add(x.a, x.b))
  end
end
