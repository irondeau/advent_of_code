defmodule AdventOfCode.Y2023.D6 do
  use AdventOfCode.Puzzle, year: 2023, day: 6

  @impl true
  def title, do: "Wait For It"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
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
      quadratic(-1, time, -record)
      |> then(fn [x1, x2] -> (floor(x2 - 0.0001) - ceil(x1 + 0.0001)) + 1 end)
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

    quadratic(-1, time, -record)
    |> then(fn [x1, x2] -> (floor(x2 - 0.0001) - ceil(x1 + 0.0001)) + 1 end)
  end

  defp quadratic(a, b, c) do
    d = b**2 - 4 * a * c

    if d >= 0 do
      x1 = (-b + :math.sqrt(d)) / (2 * a)
      x2 = (-b - :math.sqrt(d)) / (2 * a)

      [x1, x2]
    else
      nil
    end
  end
end
