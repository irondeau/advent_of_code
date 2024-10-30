defmodule AdventOfCode.Y2023.D25 do
  use AdventOfCode.Puzzle, year: 2023, day: 25

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
    |> Enum.reduce(Graph.new(type: :undirected), fn line, graph ->
      [from, rest] = String.split(line, ": ")

      graph = Graph.add_vertex(graph, from)

      rest
      |> String.split()
      |> Enum.reduce(graph, fn to, graph ->
        graph
        |> Graph.add_vertex(to)
        |> Graph.add_edge(from, to)
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
    |> Graph.edges()
    |> combinations()
    |> Enum.reduce_while(nil, fn edges, _ ->
      graph = Graph.delete_edges(graph, edges)

      case Graph.components(graph) |> length() do
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
