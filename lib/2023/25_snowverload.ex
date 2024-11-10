defmodule AdventOfCode.Y2023.D25 do
  use AdventOfCode.Puzzle, year: 2023, day: 25

  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "Snowverload"

  @impl true
  def solve(graph) do
    vertices = :digraph.vertices(graph)

    for _ <- 0..round(length(vertices) / 2) do
      [v1, v2] = Enum.take_random(vertices, 2)
      :digraph.get_short_path(graph, v1, v2)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&MapSet.new(&1))
    end
    |> Enum.concat()
    |> Enum.frequencies()
    |> Enum.sort_by(fn {_, freq} -> freq end, :desc)
    |> Enum.map(&elem(&1, 0))
    |> Enum.take(3)
    |> Enum.each(fn edge ->
      [v1, v2] = MapSet.to_list(edge)
      Digraph.del_edge(graph, v1, v2)
      Digraph.del_edge(graph, v2, v1)
    end)

    :digraph_utils.components(graph)
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  @impl true
  def parse(input) do
    graph = :digraph.new()

    input
    |> String.split(~r/\R/)
    |> Enum.each(fn line ->
      [from, rest] = String.split(line, ": ")
      :digraph.add_vertex(graph, from)

      rest
      |> String.split()
      |> Enum.each(fn to ->
        :digraph.add_vertex(graph, to)
        :digraph.add_edge(graph, from, to)
        :digraph.add_edge(graph, to, from)
      end)
    end)

    graph
  end
end
