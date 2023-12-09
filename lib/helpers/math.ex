defmodule AdventOfCode.Helpers.Math do
  @moduledoc """
  Mathematical helper functions which extend Elixir's standard library.
  """

  @spec gcd(integer(), integer()) :: non_neg_integer()
  def gcd(a, 0), do: abs(a)
  def gcd(0, b), do: abs(b)
  def gcd(a, b), do: gcd(b, rem(a, b))

  @spec gcd(Enumerable.t()) :: non_neg_integer()
  def gcd(enumerable), do: Enum.reduce(enumerable, &gcd/2)

  @spec lcm(integer(), integer()) :: non_neg_integer()
  def lcm(0, 0), do: 0
  def lcm(a, b), do: abs(div(a * b, gcd(a, b)))

  @spec lcm([integer()]) :: non_neg_integer()
  def lcm(enumerable), do: Enum.reduce(enumerable, &lcm/2)

  @spec quadratic(number(), number(), number()) :: [float()] | float() | nil
  def quadratic(a, b, c) do
    d = b ** 2 - 4 * a * c

    cond do
      d > 0 ->
        x1 = (-b + :math.sqrt(d)) / (2 * a)
        x2 = (-b - :math.sqrt(d)) / (2 * a)

        [x1, x2]

      d == 0 ->
        (-b + :math.sqrt(d)) / (2 * a)

      true ->
        nil
    end
  end
end
