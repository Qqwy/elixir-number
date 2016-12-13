# Numbers

**Numbers** is a tiny Elixir package that facilitates the creation of libraries
that want to be able to use _any_ kind of Numeric type.

Some known custom numeric types that implement the Numeric behaviour:

- [Ratio](https://hex.pm/packages/ratio) -- rational numbers.
- [Decimal](https://hex.pm/packages/decimal) -- arbitrary precision decimal numbers.
- [Tensor](https://hex.pm/packages/tensor) -- Vectors, Matrices and higher-order tensors.
- [ComplexNum](https://github.com/Qqwy/elixir_complex_num) -- Complex numbers.

## How does it work?

This is done by writing a Behaviour called `Numeric`, which standardizes the names of the following common mathematical operations:

- `new` to create a new number of the custom type from a basic integer or float (which be an operation that loses precision).
- `add` for addition.
- `sub` for subtraction.
- `mul` for multiplication.
- `div` for division.
- `minus` for unary minus (also known as negation).
- `abs` for taking the absolute value.
- `pow` _(optional)_ for calculating integer powers. When no custom algorithm is specified by the data type, Numbers will provide a (possibly slower) variant itself using the Exponentiation by Squaring algorithm.
- `to_float` _(optional)_ For some Numeric data types it is possible to convert it back to a built-in datatype (possibly losing precision in the process).

The `Numbers` module then dispatches these functions to YourStructModule when called with a `%YourStructModule{}` struct as one or both of its arguments.
If the other argument is a Float or Integer, then it is first converted to an instance of YourStruct by calling `YourStructModule.new(the_int_or_float)` on it.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `number` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:number, "~> 1.0.0"}]
    end
    ```

  2. Ensure `number` is started before your application:

    ```elixir
    def application do
      [applications: [:number]]
    end
    ```

