defmodule AdventOfCode.Y2015.D16 do
  use AdventOfCode.Puzzle, year: 2015, day: 16

  @characteristics %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

  @impl true
  def title, do: "Aunt Sue"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn "Sue " <> line ->
      [_index, rest] = String.split(line, ": ", parts: 2)

      rest
      |> String.split(", ")
      |> Enum.map(fn item ->
        [name, count] = String.split(item, ": ")
        {name, String.to_integer(count)}
      end)
      |> Enum.into(%{})
    end)
  end

  defp solve_1(sue_list) do
    sue_list
    |> Enum.with_index(1)
    |> Enum.find(fn {sue, _index} ->
      MapSet.subset?(MapSet.new(sue), MapSet.new(@characteristics))
    end)
    |> elem(1)
  end

  defp solve_2(sue_list) do
    sue_list
    |> Enum.with_index(1)
    |> Enum.find(fn {sue, _index} ->
      @characteristics
      |> Map.take(Map.keys(sue))
      |> Enum.map(fn {key, value} ->
        cond do
          key in ["cats", "trees"] -> Map.fetch!(sue, key) > value
          key in ["pomeranians", "goldfish"] -> Map.fetch!(sue, key) < value
          true -> Map.fetch!(sue, key) == value
        end
      end)
      |> Enum.all?()
    end)
    |> elem(1)
  end
end
