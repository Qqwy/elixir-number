defimpl Numbers.Protocols.Addition, for: Float do
  def add(a, b), do: a + b
  def add_id(_), do: 0.0
end

defimpl Numbers.Protocols.Subtraction, for: Float do
  def sub(a, b), do: a - b
end

defimpl Numbers.Protocols.Multiplication, for: Float do
  def mult(a, b), do: a * b
  def mult_id(_), do: 1.0
end

defimpl Numbers.Protocols.Division, for: Float do
  def div(a, b), do: a / b
end

defimpl Numbers.Protocols.Minus, for: Float do
  def minus(num), do: -num
end

defimpl Numbers.Protocols.Absolute, for: Float do
  def abs(num) when num < 0, do: -num
  def abs(num), do: num
end

defimpl Numbers.Protocols.Exponentiation, for: Float do
  def pow(x, n) do
    :math.pow(x, n)
  end
end

defimpl Numbers.Protocols.ToFloat, for: Float do
  def to_float(x), do: x
end

# Coerce.defcoercion is avoided here because its function_exported?/3 check
# is incompatible with Elixir 1.19's parallel compiler. These defmodule blocks
# are the equivalent expansion.
defmodule Coerce.Implementations.Integer.Float do
  @moduledoc false
  def coerce(int, float), do: {int + 0.0, float}
end

defmodule Coerce.Implementations.Float.Integer do
  @moduledoc false
  def coerce(float, int), do: {float, int + 0.0}
end
