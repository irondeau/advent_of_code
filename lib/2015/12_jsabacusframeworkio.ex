defmodule AdventOfCode.Y2015.D12 do
  use AdventOfCode.Puzzle, year: 2015, day: 12

  @impl true
  def title, do: "JSAbacusFramework.io"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    Jason.decode!(input)
  end

  defp solve_1(json) do
    sum_numbers(json)
  end

  defp solve_2(json) do
    sum_numbers_without_red(json)
  end

  defp sum_numbers(json, acc \\ 0)

  defp sum_numbers(json, acc) when is_integer(json), do: acc + json

  defp sum_numbers(json, acc) when is_binary(json), do: acc

  defp sum_numbers(json, acc) when is_map(json) do
    json
    |> Map.values()
    |> sum_numbers(acc)
  end

  defp sum_numbers(json, acc) when is_list(json) do
    Enum.reduce(json, acc, &sum_numbers/2)
  end

  defp sum_numbers_without_red(json, acc \\ 0)

  defp sum_numbers_without_red(json, acc) when is_integer(json), do: acc + json

  defp sum_numbers_without_red(json, acc) when is_binary(json), do: acc

  defp sum_numbers_without_red(json, acc) when is_map(json) do
    values = Map.values(json)

    if "red" in values do
      acc
    else
      sum_numbers_without_red(values, acc)
    end
  end

  defp sum_numbers_without_red(json, acc) when is_list(json) do
    Enum.reduce(json, acc, &sum_numbers_without_red/2)
  end
end
