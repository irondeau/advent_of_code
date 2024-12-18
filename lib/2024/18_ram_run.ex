defmodule AdventOfCode.Y2024.D18 do
  use AdventOfCode.Puzzle, year: 2024, day: 18

  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "RAM Run"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [meta, bytes] = String.split(input, ~r/\R/, parts: 2)

    [width, count] =
      meta
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    bytes =
      bytes
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    grid =
      for y <- 0..width,
          x <- 0..width,
          into: MapSet.new() do
        {x, y}
      end

    fall(grid, bytes, count)
  end

  defp solve_1({graph, _rest}) do
    vs = :digraph.vertices(graph)
    start = Enum.min(vs)
    stop = Enum.max(vs)

    :digraph.get_short_path(graph, start, stop)
    |> length()
    |> Kernel.-(1)
  end

  defp solve_2({graph, rest}) do
    vs = :digraph.vertices(graph)
    start = Enum.min(vs)
    stop = Enum.max(vs)

    Enum.find(rest, fn coordinate ->
      :digraph.del_vertex(graph, coordinate)
      :digraph.get_path(graph, start, stop) == false
    end)
  end

  defp fall(grid, bytes, count) do
    {fallen, rest} = Enum.split(bytes, count)
    grid = MapSet.difference(grid, MapSet.new(fallen))

    graph = :digraph.new()
    Enum.each(grid, &:digraph.add_vertex(graph, &1))
    Enum.each(grid, fn coordinate ->
      Digraph.add_edges(graph, edges(coordinate))
    end)

    {graph, rest}
  end

  defp edges({x, y}),
    do: [
      [{x, y}, {x, y - 1}],
      [{x, y}, {x + 1, y}],
      [{x, y}, {x, y + 1}],
      [{x, y}, {x - 1, y}]
    ]
end
