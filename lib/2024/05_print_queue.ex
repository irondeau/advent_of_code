defmodule AdventOfCode.Y2024.D5 do
  use AdventOfCode.Puzzle, year: 2024, day: 5

  @impl true
  def title, do: "Print Queue"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [rules, updates] = String.split(input, ~r/\R\R/)

    rules =
      rules
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
      end)

    updates =
      updates
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  defp solve_1({rules, updates}) do
    updates
    |> Enum.filter(&(&1 == sort(&1, rules)))
    |> Enum.map(&median/1)
    |> Enum.sum()
  end

  defp solve_2({rules, updates}) do
    updates
    |> Enum.reject(&(&1 == sort(&1, rules)))
    |> Enum.map(&sort(&1, rules))
    |> Enum.map(&median/1)
    |> Enum.sum()
  end

  defp sort(update, rules) do
    Enum.sort(update, fn a, b ->
      Enum.member?(rules, [a, b])
    end)
  end

  defp median(update), do: Enum.at(update, div(length(update), 2))
end
