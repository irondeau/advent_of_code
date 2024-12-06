defmodule AdventOfCode.Y2024.D6 do
  use AdventOfCode.Puzzle, year: 2024, day: 6

  @impl true
  def title, do: "Guard Gallivant"

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
          |> Enum.map(fn {char, x} ->
            {x, char}
          end)
          |> Map.new()
        }
      end)
      |> Map.new()

    {x, y} =
      Enum.find_value(map, fn {y, inner} ->
        Enum.find_value(inner, fn {x, char} ->
          if char == "^", do: {x, y}
        end)
      end)

    map = put_in(map[y][x], ".")

    {map, {x, y}}
  end

  defp solve_1({map, start}) do
    patrol(map, start)
    |> MapSet.size()
  end

  defp solve_2({map, start}) do
    patrol(map, start)
    |> MapSet.delete(start)
    |> Task.async_stream(
      fn {x, y} ->
        put_in(map[y][x], "#")
        |> patrol(start)
      end,
      ordered: false
    )
    |> Enum.count(&match?({:ok, :loop}, &1))
  end

  defp patrol(map, position, direction \\ {0, -1}) do
    patrol(map, position, direction, MapSet.new())
  end

  defp patrol(map, position = {x, y}, direction = {dx, dy}, path) do
    if {position, direction} in path do
      :loop
    else
      path = MapSet.put(path, {position, direction})

      case map[y + dy][x + dx] do
        nil -> MapSet.new(path, fn {pos, _} -> pos end)
        "#" -> patrol(map, position, turn(direction), path)
        "." -> patrol(map, {x + dx, y + dy}, direction, path)
      end
    end
  end

  defp turn({0, -1}), do: {1, 0}
  defp turn({1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}
end
