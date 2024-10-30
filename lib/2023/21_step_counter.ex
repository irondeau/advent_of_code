defmodule AdventOfCode.Y2023.D21 do
  use AdventOfCode.Puzzle, year: 2023, day: 21

  @frame_size 131
  @frame_offset 65

  @impl true
  def title, do: "Step Counter"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), {0, 0}}, fn {line, y}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, {plot, start} = acc ->
        case char do
          "." -> {MapSet.put(plot, {x, y}), start}
          "#" -> acc
          "S" -> {MapSet.put(plot, {x, y}), {x, y}}
        end
      end)
    end)
  end

  defp solve_1({plot, start}) do
    1..64
    |> Enum.reduce(MapSet.new([start]), fn _, at ->
      step(plot, at)
    end)
    |> MapSet.size()
  end

  defp solve_2({plot, start}) do
    a0 = coefficient(plot, start, @frame_offset)
    a1 = coefficient(plot, start, @frame_size + @frame_offset)
    a2 = coefficient(plot, start, @frame_size * 2 + @frame_offset)
    n = div(26_501_365, @frame_size)

    b0 = a0
    b1 = a1 - a0
    b2 = a2 - a1

    b0 + b1 * n + div(n * (n - 1), 2) * (b2 - b1)
  end

  defp coefficient(plot, start, step) do
    1..step
    |> Enum.reduce(MapSet.new([start]), fn _, at ->
      step(plot, at, infinite: true)
    end)
    |> MapSet.size()
  end

  defp step(plot, at, opts \\ [infinite: false]) do
    at
    |> Enum.reduce(MapSet.new(), fn {x, y}, next ->
      adjacent_tiles(plot, {x, y}, opts)
      |> MapSet.union(next)
    end)
  end

  defp adjacent_tiles(plot, {x, y}, opts) do
    adjacent =
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]

    if Keyword.get(opts, :infinite) do
      adjacent
      |> Enum.reduce(MapSet.new(), fn {dx, dy}, tiles ->
        if MapSet.member?(plot, {Integer.mod(dx, @frame_size), Integer.mod(dy, @frame_size)}) do
          MapSet.put(tiles, {dx, dy})
        else
          tiles
        end
      end)
    else
      MapSet.intersection(plot, MapSet.new(adjacent))
    end
  end
end
