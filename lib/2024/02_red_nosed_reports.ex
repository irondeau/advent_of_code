defmodule AdventOfCode.Y2024.D2 do
  use AdventOfCode.Puzzle, year: 2024, day: 2

  @impl true
  def title, do: "Red-Nosed Reports"

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
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp solve_1(reports) do
    reports
    |> Enum.filter(&is_safe/1)
    |> Enum.count()
  end

  defp solve_2(reports) do
    reports
    |> Enum.filter(&is_safe(&1, tolerate: 1))
    |> Enum.count()
  end

  defp is_safe(report) do
    diffs =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)

    Enum.all?(diffs, &(&1 in 1..3)) or Enum.all?(diffs, &(&1 in -1..-3//-1))
  end

  defp is_safe(report, tolerate: 1) do
    0..(length(report) - 1)
    |> Enum.any?(fn i ->
      report
      |> List.delete_at(i)
      |> is_safe()
    end)
  end
end
