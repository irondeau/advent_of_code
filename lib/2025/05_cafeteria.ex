defmodule AdventOfCode.Y2025.D5 do
  use AdventOfCode.Puzzle, year: 2025, day: 5

  @impl true
  def title, do: "Cafeteria"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [range_input, ingredient_input] =
      input
      |> String.trim()
      |> String.split(~r/\R\R/)

    ranges =
      range_input
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> then(fn [start, stop] -> Range.new(start, stop) end)
      end)

    ingredients =
      ingredient_input
      |> String.split(~r/\R/)
      |> Enum.map(&String.to_integer/1)

    {ranges, ingredients}
  end

  defp solve_1({ranges, ingredients}) do
    ingredients
    |> Enum.filter(fn ingredient ->
      Enum.any?(ranges, fn range ->
        ingredient in range
      end)
    end)
    |> Enum.count()
  end

  defp solve_2({ranges, ingredients}) do
    ingredients
    |> Enum.reduce({ranges, []}, fn ingredient, {ranges, acc} ->
      {next_ranges, fresh} =
        Enum.split_with(ranges, fn range ->
          ingredient in range
        end)

      {next_ranges, fresh ++ acc}
    end)
    |> elem(1)
    |> range_merge()
    |> Enum.sum_by(&Range.size/1)
  end

  defp range_merge(ranges, acc \\ [])

  defp range_merge([], acc), do: acc

  defp range_merge([first | _] = ranges, acc) do
    {disjoint_ranges, joint_ranges} =
      Enum.split_with(ranges, fn range ->
        Range.disjoint?(range, first)
      end)

    case joint_ranges do
      [^first] -> range_merge(disjoint_ranges, [first | acc])
      joint_ranges -> range_merge([do_merge(joint_ranges) | disjoint_ranges], acc)
    end
  end

  defp do_merge(joint_ranges) do
    first = joint_ranges |> Enum.map(& &1.first) |> Enum.min()
    last = joint_ranges |> Enum.map(& &1.last) |> Enum.max()

    Range.new(first, last)
  end
end
