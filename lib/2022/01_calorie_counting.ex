defmodule AdventOfCode.Y2022.D1 do
  use AdventOfCode.Puzzle, year: 2022, day: 1

  @impl true
  def title, do: "Calorie Counting"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R\R/)
    |> Enum.map(fn inventory ->
      inventory
      |> String.split(~r/\R/)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&Enum.sum/1)
  end

  defp solve_1(inventories) do
    inventories
    |> Enum.max()
  end

  defp solve_2(inventories) do
    inventories
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
