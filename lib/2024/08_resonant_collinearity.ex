defmodule AdventOfCode.Y2024.D8 do
  use AdventOfCode.Puzzle, year: 2024, day: 8

  alias AdventOfCode.Helpers.Math

  @impl true
  def title, do: "Resonant Collinearity"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    antenna_map =
      lines
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {line, y}, antenna_map ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(antenna_map, fn
          {".", _x}, antenna_map -> antenna_map
          {char, x}, antenna_map -> Map.update(antenna_map, char, [{x, y}], &[{x, y} | &1])
        end)
      end)

    size_y = length(lines)
    size_x = String.length(hd(lines))

    {antenna_map, {size_x, size_y}}
  end

  defp solve_1({antenna_map, {size_x, size_y}}) do
    for {_name, antennas} <- antenna_map,
        {x1, y1} <- antennas,
        {x2, y2} <- antennas,
        {x1, y1} != {x2, y2},
        {dx, dy} = {x2 - x1, y2 - y1},
        {x, y} = {x1 - dx, y1 - dy},
        x >= 0 and x < size_x and y >= 0 and y < size_y,
        into: MapSet.new() do
      {x, y}
    end
    |> MapSet.size()
  end

  defp solve_2({antenna_map, {size_x, size_y}}) do
    for {_name, antennas} <- antenna_map,
        {x1, y1} <- antennas,
        {x2, y2} <- antennas,
        {x1, y1} != {x2, y2},
        {dx, dy} = {x2 - x1, y2 - y1},
        n <- 0..round(Math.pythagorean(size_x, size_y)),
        {x, y} = {x1 - n * dx, y1 - n * dy},
        x >= 0 and x < size_x and y >= 0 and y < size_y,
        into: MapSet.new() do
      {x, y}
    end
    |> MapSet.size()
  end
end
