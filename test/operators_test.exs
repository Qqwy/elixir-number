defmodule OperatorsTest do
  use ExUnit.Case

  use Numbers, overload_operators: true

  test "+/2 works" do
    assert 1 + 2 == 3
    assert Decimal.new(1) + 2 == Decimal.new(3)
    assert NumericPair.new(1, 2) + NumericPair.new(3, 4) == NumericPair.new(4, 6)
  end


  test "-/2 works" do
    assert 1 - 2 == -1
    assert Decimal.new(1) - 2 == Decimal.new(-1)
    assert NumericPair.new(1, 2) - NumericPair.new(3, 4) == NumericPair.new(-2, -2)
  end

  test "*/2 works" do
    assert 1 * 2 == 2
    assert Decimal.new(1) * 2 == Decimal.new(2)
    assert NumericPair.new(1, 2) * NumericPair.new(3, 4) == NumericPair.new(3, 8)
  end

  test "//2 works" do
    assert 1 / 2 == 0.5
    assert Decimal.new(1) / 2 == Decimal.from_float(0.5)
    assert NumericPair.new(1, 2) / NumericPair.new(3, 4) == NumericPair.new(1 / 3, 0.5)
  end

  for {fun, operator} <- [add: :+, sub: :-, mult: :*, div: :/] do
    test "Calling operator `#{operator}` in guards still works and calls guard-safe Kernel variants." do
      defmodule unquote(Module.concat(Conflict, fun)) do
        use Numbers, overload_operators: true

        # This does not compile if `operator` in guard does not compile to Kernel.+/2.
        def foo(a, b) when unquote(operator)(a, b) < 10, do: true
        def foo(c, d), do: unquote(operator)(c, d)
      end
    end
  end
end
