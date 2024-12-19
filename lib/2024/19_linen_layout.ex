defmodule AdventOfCode.Y2024.D19 do
  use AdventOfCode.Puzzle, year: 2024, day: 19
  use Memoize

  @impl true
  def title, do: "Linen Layout"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [towels, designs] = String.split(input, ~r/\R\R/)

    towels =
      towels
      |> String.split(", ")
      |> Enum.sort(:desc)

    {towels, String.split(designs, ~r/\R/)}
  end

  defp solve_1({towels, designs}) do
    designs
    |> Task.async_stream(&possible?(towels, &1))
    |> Enum.count(&elem(&1, 1))
  end

  defp solve_2({towels, designs}) do
    designs
    |> Task.async_stream(&count_possible(towels, &1))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defmemop possible?(_towels, ""), do: true

  defmemop possible?(towels, design) do
    Enum.any?(towels, fn towel ->
      if String.starts_with?(design, towel) do
        subdesign = String.replace_prefix(design, towel, "")
        possible?(towels, subdesign)
      end
    end)
  end

  defmemop count_possible(_towels, ""), do: 1

  defmemop count_possible(towels, design) do
    towels
    |> Enum.filter(fn towel ->
      String.starts_with?(design, towel)
    end)
    |> Enum.map(fn towel ->
      subdesign = String.replace_prefix(design, towel, "")
      count_possible(towels, subdesign)
    end)
    |> Enum.sum()
  end
end
