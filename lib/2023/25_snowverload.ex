defmodule AdventOfCode.Y2023.D25 do
  use AdventOfCode.Puzzle, year: 2023, day: 25

  alias AdventOfCode.Helpers.UndirectedGraph
  import IEx

  @impl true
  def title, do: "Snowverload"

  @impl true
  def solve(graph) do
    vertices = UndirectedGraph.vertices(graph)

    0..round(length(vertices) / 2)
    |> Enum.flat_map(fn _ ->
      [a, b] = Enum.take_random(vertices, 2)
      graph
      |> UndirectedGraph.dijkstra(a, b)
      |> Map.keys()
    end)
    |> Enum.frequencies()
    |> Enum.sort_by(fn {_, freq} -> freq end, :desc)
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.take(3)
    |> then(fn cut_edges ->
      graph
      |> UndirectedGraph.delete_edges(cut_edges)
      |> UndirectedGraph.components()
      |> Enum.map(&length/1)
      |> Enum.product()
    end)
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.reduce(UndirectedGraph.new(), fn line, graph ->
      [from, rest] = String.split(line, ": ")

      rest
      |> String.split()
      |> Enum.reduce(graph, fn to, graph ->
        UndirectedGraph.add_edge(graph, from, to)
      end)
    end)
  end
end
