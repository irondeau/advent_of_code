defmodule AdventOfCode.Y2022.D3 do
  use AdventOfCode.Puzzle, year: 2022, day: 3

  @impl true
  def title, do: "Rucksack Reorganization"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
  end

  defp solve_1(rucksacks) do
    rucksacks
    |> Enum.map(fn line ->
      split_pos = String.length(line) |> div(2)

      line
      |> String.split_at(split_pos)
      |> Tuple.to_list()
      |> Enum.map(fn compartment ->
        compartment
        |> String.graphemes()
        |> Enum.into(MapSet.new())
      end)
      |> List.to_tuple()
    end)
    |> Enum.map(fn {first, second} ->
      MapSet.intersection(first, second)
      |> MapSet.to_list()
      |> hd()
    end)
    |> score()
  end

  defp solve_2(rucksacks) do
    rucksacks
    |> Enum.map(fn rucksack ->
      rucksack
      |> String.graphemes()
      |> MapSet.new()
    end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn group ->
      group
      |> Enum.reduce(fn rucksack, acc ->
        MapSet.intersection(acc, rucksack)
      end)
      |> MapSet.to_list()
      |> hd()
    end)
    |> score()
  end

  defp score(items) when is_list(items), do: Enum.sum_by(items, &score/1)
  defp score(<<item>>) when item in ?a..?z, do: item - 96
  defp score(<<item>>) when item in ?A..?Z, do: item - 38
end
