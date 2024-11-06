defmodule AdventOfCode.Y2023.D25 do
  use AdventOfCode.Puzzle, year: 2023, day: 25

  alias AdventOfCode.Helpers.UndirectedGraph
  import IEx

  @impl true
  def title, do: "Snowverload"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
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

  defp solve_1(graph) do
    graph
    |> disconnect()
    |> Graph.components()
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  defp solve_2(_input) do
    nil
  end

  defp disconnect(graph) do
    graph
    |> UndirectedGraph.edges()
    |> Map.keys()
    |> combinations()
    |> Enum.reduce_while(nil, fn edges, _ ->
      graph = UndirectedGraph.delete_edges(graph, edges)

      # TODO: Implement components function. This probably won't be enough for the final solution

      case UndirectedGraph.components(graph) |> length() do
        2 -> {:halt, graph}
        _ -> {:cont, nil}
      end
    end)
  end

  defp combinations(edges) do
    for a <- edges, b <- edges, c <- edges, a != b and b != c do
      [a, b, c]
    end
  end
end
