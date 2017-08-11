defmodule Numbers.Operators do
  # Do not import this module directly.
  # Instead, use `use Numbers, override_operators: true`
  # which will import this module's functions properly.
  @moduledoc false

  defdelegate a + b, to: Numbers, as: :add
  defdelegate a - b, to: Numbers, as: :sub
  defdelegate a * b, to: Numbers, as: :mult
  defdelegate a / b, to: Numbers, as: :div
  defdelegate -a, to: Numbers, as: :minus
  defdelegate abs(a), to: Numbers, as: :abs

  defdelegate pow(a, b), to: Numbers
end
