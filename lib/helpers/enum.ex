defmodule AdventOfCode.Helpers.Enum do
  @moduledoc """
  Enumerable helper functions which extend Elixir's standard library.
  """

  def has_dup?(enumerable) do
    Enum.reduce_while(enumerable, [], fn x, acc ->
      if x in acc, do: {:halt, false}, else: {:cont, [x | acc]}
    end)
    |> is_boolean()
  end

  def combinations(_enumerable, 0), do: [[]]
  def combinations([], _), do: []

  def combinations([head | tail], cardinality) do
    (for sub <- combinations(tail, cardinality - 1), do: [head | sub]) ++ combinations(tail, cardinality)
  end

  def permutations(enumerable), do: permutations(enumerable, length(enumerable))

  def permutations(_enumerable, 0), do: [[]]

  def permutations(enumerable, cardinality) when is_integer(cardinality) do
    k = min(cardinality, length(enumerable))
    for x <- enumerable, y <- permutations(enumerable -- [x], k - 1) do
      [x | y]
    end
  end
end
