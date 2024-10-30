defmodule AdventOfCode.Helpers.DirectedGraph do
  alias __MODULE__

  use AdventOfCode.Helpers.Graph

  @impl true
  def get_paths(%DirectedGraph{} = graph, start, stop) do
    get_paths(graph, stop, [{start, %{}}], [])
  end

  defp get_paths(%DirectedGraph{}, _stop, [], paths), do: paths

  defp get_paths(%DirectedGraph{} = graph, stop, [{current, visited} | unvisited], paths) when current == stop do
    get_paths(graph, stop, unvisited, [visited | paths])
  end

  defp get_paths(%DirectedGraph{} = graph, stop, [{current, visited} | unvisited], paths) do
    DirectedGraph.out_edges(graph, current)
    |> Map.reject(fn {_, edge} ->
      Enum.any?(visited, fn {_, visited_edge} ->
        edge.v1 == visited_edge.v1 or edge.v2 == visited_edge.v1
      end)
    end)
    |> Enum.map(fn {ref, edge} ->
      {edge.v2, Map.put(visited, ref, edge)}
    end)
    |> then(fn to_visit ->
      get_paths(graph, stop, to_visit ++ unvisited, paths)
    end)
  end

  def in_edges(%DirectedGraph{} = graph, vertex) do
    Map.filter(graph.edges, fn {_, edge} ->
      edge.v2 == vertex
    end)
  end

  def out_edges(%DirectedGraph{} = graph, vertex) do
    Map.filter(graph.edges, fn {_, edge} ->
      edge.v1 == vertex
    end)
  end
end
