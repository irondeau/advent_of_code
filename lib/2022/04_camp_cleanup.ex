defmodule AdventOfCode.Y2022.D4 do
  use AdventOfCode.Puzzle, year: 2022, day: 4

  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Camp Cleanup"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(fn section ->
        section
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> then(&apply(Range, :new, &1))
      end)
    end)
  end

  defp solve_1(camp) do
    for [section1, section2] <- camp,
        Helpers.Range.contains?(section1, section2) or Helpers.Range.contains?(section2, section1),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  defp solve_2(camp) do
    for [section1, section2] <- camp,
        not Range.disjoint?(section1, section2),
        reduce: 0 do
      acc -> acc + 1
    end
  end
end
