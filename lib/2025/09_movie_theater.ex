defmodule AdventOfCode.Y2025.D9 do
  use AdventOfCode.Puzzle, year: 2025, day: 9

  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Movie Theater"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp solve_1(tiles) do
    tiles
    |> Helpers.Enum.combinations(2)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
    end)
    |> Enum.max()
  end

  defp solve_2(tiles) do
    polygon = %Geo.Polygon{coordinates: [tiles ++ [hd(tiles)]]}

    tiles
    |> Helpers.Enum.combinations(2)
    |> Enum.filter(fn [{x1, y1}, {x2, y2}] ->
      rect = %Geo.Polygon{coordinates: [[{x1, y1}, {x1, y2}, {x2, y2}, {x2, y1}, {x1, y1}]]}
      Topo.contains?(polygon, rect)
    end)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
    end)
    |> Enum.max()
  end
end
