defmodule AdventOfCode.Y2023.D16 do
  use AdventOfCode.Puzzle, year: 2023, day: 16

  @impl true
  def title, do: "The Floor Will Be Lava"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&%{tile: &1, energized?: false, directions_accessed: MapSet.new()})
    end)
  end

  defp solve_1(input) do
    input
    |> route()
    |> get_in([Access.all(), Access.all(), :energized?])
    |> List.flatten()
    |> Enum.count(&(&1))
  end

  defp solve_2(input) do
    y_coords =
      0..length(input)
      |> Enum.flat_map(fn y ->
        [
          {{0, y}, :east},
          {{length(hd(input)) - 1, y}, :west}
        ]
      end)

    x_coords =
      0..length(hd(input))
      |> Enum.flat_map(fn x ->
        [
          {{x, 0}, :south},
          {{x, length(input) - 1}, :north}
        ]
      end)

    (y_coords ++ x_coords)
    |> Enum.map(fn {{x, y}, direction} ->
      input
      |> route({x, y}, direction)
      |> get_in([Access.all(), Access.all(), :energized?])
      |> List.flatten()
      |> Enum.count(&(&1))
    end)
    |> Enum.max()
  end

  defp route(input, {x, y} \\ {0, 0}, direction \\ :east) do
    if y < 0 or y >= length(input) or x < 0 or x >= length(hd(input)) do
      input
    else
      {current_tile, input} =
        get_and_update_in(input, [Access.at(y), Access.at(x)], fn current_tile ->
          {current_tile, %{current_tile | energized?: true}}
        end)

      outbound_paths =
        get_outbound_paths(Map.get(current_tile, :tile), {x, y}, direction)

      outbound_directions =
        get_in(outbound_paths, [Access.all(), Access.elem(1)])
        |> MapSet.new()

      if MapSet.subset?(outbound_directions, Map.get(current_tile, :directions_accessed)) do
        input
      else
        input =
          update_in(input, [Access.at(y), Access.at(x), :directions_accessed], fn directions_accessed ->
            MapSet.union(directions_accessed, outbound_directions)
          end)

        outbound_paths
        |> Enum.reduce(input, fn {{x, y}, direction}, input ->
          route(input, {x, y}, direction)
        end)
      end
    end
  end

  defp get_outbound_paths(tile, {x, y}, direction) do
    {dx, dy} =
      case direction do
        :north -> {0, -1}
        :east -> {1, 0}
        :south -> {0, 1}
        :west -> {-1, 0}
      end

    cond do
      tile == "|" and direction in [:east, :west] ->
        [
          {{x, y - 1}, :north},
          {{x, y + 1}, :south}
        ]

      tile == "-" and direction in [:north, :south] ->
        [
          {{x + 1, y}, :east},
          {{x - 1, y}, :west}
        ]

      tile == "\\" ->
        outbound_direction =
          %{
            north: :west,
            east: :south,
            south: :east,
            west: :north
          }
          |> Map.get(direction)

        [{{x + dy, y + dx}, outbound_direction}]

      tile == "/" ->
        outbound_direction =
          %{
            north: :east,
            east: :north,
            south: :west,
            west: :south
          }
          |> Map.get(direction)

        [{{x - dy, y - dx}, outbound_direction}]

      true ->
        [{{x + dx, y + dy}, direction}]
    end
  end
end
