defmodule AdventOfCode.Y2015.D13 do
  use AdventOfCode.Puzzle, year: 2015, day: 13

  @impl true
  def title, do: "Knights of the Dinner Table"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
  end

  defp solve_1(_input) do
    nil
  end

  defp solve_2(_input) do
    nil
  end
end
