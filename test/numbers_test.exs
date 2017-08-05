defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  alias Numbers, as: N

  binary_operations = [add: &+/2, sub: &-/2, mult: &*/2, div: &//2]
  builtin_types = %{Integer => [{1,2}, {3,4}, {5,6}, {1234, -5678}, {-100, 10}],
                    Float   => [{1.0, 2.0}, {123.4, 56.78}, {3.141572, 99812341233212314123.3}]}

  for {type, pairs} <- builtin_types do
    for {lhs, rhs} <- pairs do
      for {operation, kernel_operation} <- binary_operations do
        # builtin + builtin
        test "Numbers.#{operation}/2 delegates to Kernel function #{inspect(kernel_operation)} for built-in #{type} (#{lhs}, #{rhs})." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert N.unquote(operation)(a, b) === unquote(kernel_operation).(a, b)
        end


        # struct + builtin
        test "Using built-in type #{lhs} (#{type}) as RHS in Numbers.#{operation}/2 works." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert N.unquote(operation)(NumericPair.new(a, b), b) == NumericPair.new(N.unquote(operation)(a, b), N.unquote(operation)(b, b))
        end

        # builtin + struct
        test "Using built-in type #{lhs} (#{type}) as LHS in Numbers.#{operation}/2 works." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert N.unquote(operation)(a, NumericPair.new(a, b)) == NumericPair.new(N.unquote(operation)(a, a), N.unquote(operation)(a, b))
        end

        # struct + struct
        test "Simple usage of Struct as both operands for Numbers.#{operation}/2 works (filled with {#{lhs}, #{rhs}})" do
          a = unquote(lhs)
          b = unquote(rhs)
          assert N.unquote(operation)(NumericPair.new(a, b), NumericPair.new(b, a)) == NumericPair.new(N.unquote(operation)(a, b), N.unquote(operation)(b, a))
        end

        # Error raising if coercion not supported
        # struct + builtin
        test "CannotCoerceError is raised when using built-in type #{lhs} (#{type}) as RHS in Numbers.#{operation}/2 for a type that does not have new/1." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert_raise UndefinedFunctionError, fn ->
            N.unquote(operation)(NumericPairWithoutCoercion.new(a, b), b) == NumericPairWithoutCoercion.new(N.unquote(operation)(a, b), N.unquote(operation)(b, b))
          end

        end

        # builtin + struct
        test "CannotCoerceError is raised when using built-in type #{lhs} (#{type}) as LHS in Numbers.#{operation}/2 for a type that does not have new/1." do
          a = unquote(lhs)
          b = unquote(rhs)
          assert_raise UndefinedFunctionError, fn ->
            N.unquote(operation)(a, NumericPairWithoutCoercion.new(a, b)) == NumericPairWithoutCoercion.new(N.unquote(operation)(a, a), N.unquote(operation)(a, b))
          end
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

      test "Numbers.to_float/1 is supported for built-in #{type}s (called with #{lhs} as argument)" do
        assert N.to_float(unquote(lhs)) === Kernel.*(1.0, unquote(lhs))
      end

      test "Numbers.to_float(%SomeStruct{}) works if SomeStruct supports to_float/1 conversion. ({#{lhs}, #{rhs}})" do
        a = NumericPair.new(unquote(lhs), unquote(rhs))
        assert N.to_float(a) === Kernel.*(1.0, Kernel.+(unquote(lhs), unquote(rhs)))
      end

      test "Numbers.to_float(%SomeStruct{}) will raise a Protocol.UndefinedError if SomeStruct does not implement the required protocol for the  to_float/1 conversion. ({#{lhs}, #{rhs}})" do
        a = NumericPairWithoutCoercion.new(unquote(lhs), unquote(rhs))
        assert_raise Protocol.UndefinedError, fn ->
          N.to_float(a) === Kernel.*(1.0, Kernel.+(unquote(lhs), unquote(rhs)))
       end
      end
    end
  end
end
