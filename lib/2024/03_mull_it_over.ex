defmodule AdventOfCode.Y2024.D3 do
  use AdventOfCode.Puzzle, year: 2024, day: 3

  @impl true
  def title, do: "Mull It Over"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)|don?'?t?\(\)/, input)
    |> Enum.map(fn
      ["do()"] -> :enabled
      ["don't()"] -> :disabled
      [_mul, x, y] -> String.to_integer(x) * String.to_integer(y)
    end)
  end

  defp solve_1(memory) do
    memory
    |> Enum.reject(&is_atom/1)
    |> Enum.sum()
  end

  defp solve_2(memory) do
    memory
    |> Enum.reverse()
    |> Enum.reduce([[], []], fn
      :disabled, [acc, _chunk] -> [acc, []]
      :enabled, [acc, chunk] -> [[chunk | acc], []]
      value, [acc, chunk] -> [acc, [value | chunk]]
    end)
    |> List.flatten()
    |> Enum.sum()
  end
end
