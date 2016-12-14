defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  alias Numbers, as: N

  binary_operations = [add: &+/2, sub: &-/2, mult: &*/2, div: &//2]
  builtin_types = %{Integer => [{1,2}, {3,4}, {5,6}, {1234, 5678}, {0, 10}],
                    Float   => [{1.0, 2.0}, {123.4, 56.78}, {3.141572, 99812341233212314123.3}]}

  for {type, pairs} <- builtin_types do
    for {lhs, rhs} <- pairs do

      for {operation, kernel_operation} <- binary_operations do
        IO.inspect({lhs, rhs})
        test "Numbers.#{operation}/2 delegates to Kernel function #{inspect(kernel_operation)} for built-in #{type} (#{lhs}, #{rhs})." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert N.unquote(operation)(a, b) === unquote(kernel_operation).(a, b)
        end
      end

      test "Numbers.minus/1 works for #{type} #{rhs}" do
        a = unquote(lhs)
        assert N.minus(a) === Kernel.-(a)
      end

      test "Numbers.abs/1 works for #{type} #{rhs}" do
        a = unquote(lhs)
        assert N.abs(a) === Kernel.abs(a)
      end

      if type == Float do
        for power <- 1..20 do
          test "Numbers.pow(#{lhs}, #{power}) delegates to :math.pow/2 for Floats" do
            a = unquote(lhs)
            n = unquote(power)
            assert N.pow(a, n) === :math.pow(a, n)
          end
        end
      end
      
      if type == Integer do
        for power <- 1..20 do
          test "Numbers.pow(#{lhs}, #{power}) for Integers performs Exponentiation by Squaring (same result as repeated multiplication but faster)" do
            a = unquote(lhs)
            n = unquote(power)
            repeated_multiplication = Stream.cycle([a]) |> Enum.take(n) |> Enum.reduce(&*/2)
            assert N.pow(a, n) === repeated_multiplication
          end
        end
      end


      # Coercion into structs

      test "FOO #{lhs}" do
        a = unquote(lhs)
        b = unquote(rhs)
        assert N.add(NumericPair.new(a, b), b) == NumericPair.new(N.add(a, b), b)
      end

    end
  end
end
