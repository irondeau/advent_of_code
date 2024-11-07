defmodule AdventOfCode.Helpers.UndirectedGraph do
  alias __MODULE__

  use AdventOfCode.Helpers.Graph

  alias AdventOfCode.Helpers.PQ

  def components(%UndirectedGraph{} = graph) do
    components(graph, UndirectedGraph.vertices(graph))
  end

  defp components(graph, vertices, components \\ [])

  defp components(%UndirectedGraph{} = graph, [], components), do: components

  defp components(%UndirectedGraph{} = graph, [vertex | unvisited], components) do
    subgraph = UndirectedGraph.subgraph(graph, [vertex])

    unvisited =
      MapSet.difference(MapSet.new(unvisited), subgraph.vertices)
      |> MapSet.to_list()

    components(graph, unvisited, [UndirectedGraph.vertices(subgraph) | components])
  end

  def subgraph(%UndirectedGraph{} = graph, vertices), do: subgraph(graph, vertices, UndirectedGraph.new())

  defp subgraph(%UndirectedGraph{} = graph, [], acc), do: acc

  defp subgraph(%UndirectedGraph{} = graph, [vertex | unvisited], acc) do
    unvisited_edges =
      UndirectedGraph.edges(graph, vertex)
      |> Map.reject(fn {ref, _} ->
        Map.has_key?(acc.edges, ref)
      end)

    acc =
      Enum.reduce(unvisited_edges, acc, fn {ref, edge}, acc ->
        acc
        |> UndirectedGraph.add_vertex(edge.v1)
        |> UndirectedGraph.add_vertex(edge.v2)
        |> update_in([Access.key!(:edges)], &Map.put(&1, ref, edge))
      end)

    unvisited =
      Enum.flat_map(unvisited_edges, fn {ref, edge} ->
        [edge.v1, edge.v2]
      end)
      |> Enum.concat(unvisited)
      |> Enum.uniq()
      |> Enum.reject(& &1 == vertex)

    subgraph(UndirectedGraph.delete_vertex(graph, vertex), unvisited, acc)
  end

  def dijkstra(%UndirectedGraph{} = graph, a, b) do
    pq =
      PQ.new(fn {_n1, w1, _es1}, {_n2, w2, _es2} -> w1 < w2 end)
      |> PQ.push({a, 0, %{}})

    dijkstra(graph, a, b, pq)
  end

  defp dijkstra(%UndirectedGraph{} = graph, a, b, %PQ{} = pq, visited \\ %{}) do
    if PQ.empty?(pq) do
      :error
    else
      {{n, w, es}, pq} = PQ.pop(pq)

      if b == n do
        es
      else
        unvisited_edges =
          UndirectedGraph.edges(graph, n)
          |> Map.reject(fn {ref, _} ->
            Map.has_key?(visited, ref)
          end)

        Enum.map(unvisited_edges, fn {ref, edge} ->
          next = if edge.v1 == n, do: edge.v2, else: edge.v1
          {next, w + edge.weight, Map.put(es, ref, edge)}
        end)
        |> Enum.reduce(pq, &PQ.push(&2, &1))
        |> then(fn pq ->
          dijkstra(graph, a, b, pq, Map.merge(visited, unvisited_edges))
        end)
      end
    end
  end
end
