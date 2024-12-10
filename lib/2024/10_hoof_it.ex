defmodule AdventOfCode.Y2024.D10 do
  use AdventOfCode.Puzzle, year: 2024, day: 10

  @impl true
  def title, do: "Hoof It"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    map =
      input
      |> String.split(~r/\R/)
      |> Enum.with_index()
      |> Enum.map(fn {line, y} ->
        {
          y,
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.map(fn {char, x} -> {x, String.to_integer(char)} end)
          |> Map.new()
        }
      end)
      |> Map.new()

    trailheads =
      Enum.reduce(map, [], fn {y, inner}, trailheads ->
        Enum.reduce(inner, trailheads, fn
          {x, 0}, trailheads -> [{x, y} | trailheads]
          _, trailheads -> trailheads
        end)
      end)

    {map, trailheads}
  end

  defp solve_1({map, trailheads}) do
    trailheads
    |> Enum.map(fn trailhead ->
      traverse(map, trailhead, 0)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp solve_2({map, trailheads}) do
    trailheads
    |> Enum.map(fn trailhead ->
      traverse(map, trailhead, 0)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp traverse(_map, step, 9), do: [step]

  defp traverse(map, {x, y}, height) do
    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn {x, y} ->
      map[y][x] == height + 1
    end)
    |> Enum.flat_map(&traverse(map, &1, height + 1))
  end
end
