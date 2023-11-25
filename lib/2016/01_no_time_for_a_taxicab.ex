defmodule AdventOfCode.Y2016.D1 do
  use AdventOfCode.Puzzle, year: 2016, day: 1

  @impl true
  def title, do: "No Time For A Taxicab"

  @impl true
  def solve(input) do
    input
    |> String.trim()
    |> then(fn input -> {solve_pt_1(input), solve_pt_2(input)} end)
  end

  defp solve_pt_1(_input) do
    nil
  end

  defp solve_pt_2(_input) do
    nil
  end
end
