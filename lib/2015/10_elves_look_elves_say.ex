defmodule AdventOfCode.Y2015.D10 do
  use AdventOfCode.Puzzle, year: 2015, day: 10

  @impl true
  def title, do: "Elves Look, Elves Say"

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

  defp solve_1(input) do
    Enum.reduce(1..40, input, fn _, acc -> look_and_say(acc) end)
    |> List.to_string()
    |> String.length()
  end

  defp solve_2(input) do
    Enum.reduce(1..50, input, fn _, acc -> look_and_say(acc) end)
    |> List.to_string()
    |> String.length()
  end

  defp look_and_say(input) do
    Enum.reduce(input, [], fn c, acc ->
      case acc do
        [num | [count | rest]] when num === c -> [num | [count + 1 | rest]]
        _ -> [c | [1 | acc]]
      end
    end)
    |> Enum.reverse()
    |> Enum.into([], &to_string/1)
  end
end
