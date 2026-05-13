# Implementations for the :decimal library.
# Implementation exists inside Numbers
# because it is the newer and less mature library of the two.

if Code.ensure_loaded?(Decimal) do
  defimpl Numbers.Protocols.Addition, for: Decimal do
    defdelegate add(a, b), to: Decimal
    def add_id(_num), do: Decimal.new(0)
  end

  defimpl Numbers.Protocols.Subtraction, for: Decimal do
    defdelegate sub(a, b), to: Decimal
  end

  defimpl Numbers.Protocols.Multiplication, for: Decimal do
    defdelegate mult(a, b), to: Decimal
    def mult_id(_num), do: Decimal.new(1)
  end

  defimpl Numbers.Protocols.Division, for: Decimal do
    defdelegate div(a, b), to: Decimal
  end

  defimpl Numbers.Protocols.Minus, for: Decimal do
    defdelegate minus(num), to: Decimal, as: :negate
  end

  defimpl Numbers.Protocols.Absolute, for: Decimal do
    defdelegate abs(num), to: Decimal
  end

  defimpl Numbers.Protocols.ToFloat, for: Decimal do
    defdelegate to_float(num), to: Decimal
  end

  defimpl Numbers.Protocols.Exponentiation, for: Decimal do
    defdelegate pow(num, power), to: Numbers.Helper, as: :pow_by_sq
  end

  # Coerce.defcoercion is avoided here because its function_exported?/3 check
  # is incompatible with Elixir 1.19's parallel compiler. These defmodule blocks
  # are the equivalent expansion.
  # Decimal.from_float/1 replaces Decimal.new/1 for floats (removed in Decimal 3.0).
  defmodule Coerce.Implementations.Decimal.Integer do
    @moduledoc false
    def coerce(decimal, integer), do: {decimal, Decimal.new(integer)}
  end

  defmodule Coerce.Implementations.Integer.Decimal do
    @moduledoc false
    def coerce(integer, decimal), do: {Decimal.new(integer), decimal}
  end

  defmodule Coerce.Implementations.Decimal.Float do
    @moduledoc false
    def coerce(decimal, float), do: {decimal, Decimal.from_float(float)}
  end

  defmodule Coerce.Implementations.Float.Decimal do
    @moduledoc false
    def coerce(float, decimal), do: {Decimal.from_float(float), decimal}
  end
end
