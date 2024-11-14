defmodule AdventOfCode.Y2023.D6 do
  use AdventOfCode.Puzzle, year: 2023, day: 6

  import AdventOfCode.Helpers.Math

  @impl true
  def title, do: "Wait For It"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.replace(~r/[A-Za-z:]/, "")
    |> String.split(~r/\R/)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.map(fn {time, record} ->
      quadratic(-1, time, -record - 1)
      |> then(fn [x1, x2] -> floor(x2) - ceil(x1) + 1 end)
    end)
    |> Enum.product()
  end

  defp solve_2(input) do
    [time, record] =
      input
      |> Enum.map(fn line ->
        line
        |> String.replace(~r/\s/, "")
        |> String.to_integer()
      end)

    quadratic(-1, time, -record - 1)
    |> then(fn [x1, x2] -> floor(x2) - ceil(x1) + 1 end)
  end
end
