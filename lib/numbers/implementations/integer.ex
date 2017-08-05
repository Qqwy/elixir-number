defimpl Numbers.ProtocolsAddition, for: Integer do
  def add(a, b), do: a + b
  def add_id(), do: 0
end

defimpl Numbers.ProtocolsSubtraction, for: Integer do
  def sub(a, b), do: a - b
end

defimpl Numbers.ProtocolsMultiplication, for: Integer do
  def mult(a, b), do: a * b
  def mult_id(), do: 1
end

defimpl Numbers.ProtocolsDivision, for: Integer do
  # import Kernel, except: [div: 2]
  def div(a, b), do: Kernel.div(a, b)
end

defimpl Numbers.Protocols.Minus, for: Integer do
  def minus(num), do: -num
end

defimpl Numbers.Protocols.Absolute, for: Integer do
  def abs(num) when num < 0, do: -num
  def abs(num), do: num
end

defimpl Numbers.Protocols.Exponentiation, for: Integer do
  def pow(x, n) do
    Numbers.Helper.pow_by_sq(x, n)
  end
end
