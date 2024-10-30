defmodule AdventOfCode.Y2015.D1 do
  use AdventOfCode.Puzzle, year: 2015, day: 1

  @impl true
  def title, do: "Not Quite Lisp"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.graphemes()
  end

  defp solve_1(graphemes) do
    graphemes
    |> Enum.reduce(0, fn char, acc ->
      case char do
        "(" -> acc + 1
        ")" -> acc - 1
      end
    end)
  end

  defp solve_2(graphemes) do
    graphemes
    |> Enum.reduce_while([pos: 0, idx: 0], fn char, acc ->
      if acc[:pos] < 0 do
        {:halt, acc}
      else
        case char do
          "(" -> {:cont, [pos: acc[:pos] + 1, idx: acc[:idx] + 1]}
          ")" -> {:cont, [pos: acc[:pos] - 1, idx: acc[:idx] + 1]}
        end
      end
    end)
    |> Keyword.get(:idx)
  end
end

