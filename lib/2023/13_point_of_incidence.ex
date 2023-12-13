defmodule AdventOfCode.Y2023.D13 do
  use AdventOfCode.Puzzle, year: 2023, day: 13

  @badness_1 0
  @badness_2 1

  @impl true
  def title, do: "Point Of Incidence"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R\R/)
    |> Enum.map(fn pattern ->
      pattern
      |> String.split(~r/\R/)
      |> Enum.map(&String.graphemes/1)
    end)
  end

  defp solve_1(input) do
    solve_for(input, @badness_1)
  end

  defp solve_2(input) do
    solve_for(input, @badness_2)
  end

  defp solve_for(input, badness) do
    input
    |> Enum.map(fn pattern ->
      horizontal_mirrors = get_mirrors(pattern)

      case Map.get(horizontal_mirrors, badness) do
        nil ->
          pattern
          |> flip()
          |> get_mirrors()
          |> Map.get(badness)

        i -> i * 100
      end
    end)
    |> Enum.sum()
  end

  defp get_mirrors(pattern) do
    for i <- 1..(length(pattern) - 1) do
      badness =
        pattern
        |> Enum.split(i)
        |> then(fn {first, last} -> Enum.reverse(first) |> Enum.zip(last) end)
        |> Enum.map(fn {a, b} -> diff(a, b) end)
        |> Enum.sum()

      {badness, i}
    end
    |> Map.new()
  end

  defp diff(list1, list2, acc \\ 0)
  defp diff([], [], acc), do: acc

  defp diff([el1 | list1], [el2 | list2], acc) do
    acc = if el1 == el2, do: acc, else: acc + 1
    diff(list1, list2, acc)
  end

  defp flip(pattern) do
    pattern
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
