defmodule AdventOfCode.Y2023.D21 do
  use AdventOfCode.Puzzle, year: 2023, day: 21

  @impl true
  def title, do: "Step Counter"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
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
    f = fn n ->
      a0 = 3759
      a1 = 33496
      a2 = 92857

      b0 = a0
      b1 = a1 - a0
      b2 = a2 - a1

      b0 + b1 * n + (div(n * (n - 1), 2)) * (b2 - b1)
    end

    f.(div(26501365, 131))

    # 1..(65 + 131 * 2)
    # |> Enum.reduce(MapSet.new([start]), fn _, at ->
    #   step_2(plot, at)
    # end)
    # |> MapSet.size()
  end

  defp step(plot, at) do
    at
    |> Enum.reduce(MapSet.new(), fn {x, y}, next ->
      adjacent_plots(plot, {x, y})
      |> MapSet.union(next)
    end)
  end

  defp adjacent_plots(plot, {x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> MapSet.new()
    |> MapSet.intersection(plot)
  end

  defp step_2(plot, at) do
    at
    |> Enum.reduce(MapSet.new(), fn {x, y}, next ->
      adjacent_tiles(plot, {x, y})
      |> MapSet.union(next)
    end)
  end

  defp adjacent_tiles(plot, {x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.reduce(MapSet.new(), fn {dx, dy}, tiles ->
      if MapSet.member?(plot, {Integer.mod(dx, 131), Integer.mod(dy, 131)}) do
        MapSet.put(tiles, {dx, dy})
      else
        tiles
      end
    end)
  end
end
