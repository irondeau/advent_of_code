defmodule AdventOfCode.Y2023.D9 do
  use AdventOfCode.Puzzle, year: 2023, day: 9

  @impl true
  def title, do: "Mirage Maintenance"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> project_history()
    end)
  end

  defp solve_1(histories) do
    histories
    |> Enum.map(fn history ->
      history
      |> Enum.reduce(0, fn projection, acc ->
        List.last(projection) + acc
      end)
    end)
    |> Enum.sum()
  end

  defp solve_2(histories) do
    histories
    |> Enum.map(fn history ->
      history
      |> Enum.reduce(0, fn [first | _projection], acc ->
        first - acc
      end)
    end)
    |> Enum.sum()
  end

  defp project_history(history), do: project_history(history, [history])

  defp project_history(history, acc) do
    if Enum.all?(history, &(&1 == 0)) do
      acc
    else
      projected_history =
        history
        |> tl() # drop first element
        |> Enum.with_index()
        |> Enum.reduce([], fn {element, index}, acc ->
          [element - Enum.at(history, index) | acc]
        end)
        |> Enum.reverse()

      project_history(projected_history, [projected_history | acc])
    end
  end
end
