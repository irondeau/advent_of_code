defmodule AdventOfCode.Helpers.UndirectedGraph do
  alias __MODULE__

  use AdventOfCode.Helpers.Graph

  alias AdventOfCode.Helpers.PQ

  @impl true
  def dijkstra(%UndirectedGraph{} = graph, v1, v2) do
    pq =
      PQ.new(fn {_n1, w1, _es1}, {_n2, w2, _es2} -> w1 < w2 end)
      |> PQ.push({v1, 0, %{}})

    dijkstra(graph, v1, v2, pq)
  end

  defp dijkstra(%UndirectedGraph{} = graph, v1, v2, %PQ{} = pq, visited \\ %{}) do
    if PQ.empty?(pq) do
      :error
    else
      {{n, w, es}, pq} = PQ.pop(pq)

      if v2 == n do
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
          dijkstra(graph, v1, v2, pq, Map.merge(visited, unvisited_edges))
        end)
      end
    end
  end

  @impl true
  def get_paths(%UndirectedGraph{} = _graph, _v1, _v2), do: raise UndefinedFunctionError
end
