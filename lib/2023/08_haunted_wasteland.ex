defmodule AdventOfCode.Y2023.D8 do
  use AdventOfCode.Puzzle, year: 2023, day: 8

  import AdventOfCode.Helpers.Math

  alias AdventOfCode.Helpers.DirectedGraph

  @impl true
  def title, do: "Haunted Wasteland"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    [instr, network] = String.split(input, ~r/\R\R/, parts: 2)

    graph =
      network
      |> String.split(~r/\R/)
      |> Enum.map(&String.split(&1, ~r/[=(,) ]+/, trim: true))
      |> Enum.reduce(DirectedGraph.new(), fn [node, left, right], graph ->
        graph
        |> DirectedGraph.add_edge(node, left, label: :left)
        |> DirectedGraph.add_edge(node, right, label: :right)
      end)

    instr =
      instr
      |> String.graphemes()
      |> Enum.map(fn direction -> if direction == "L", do: :left, else: :right end)

    {graph, instr}
  end

  defp solve_1({graph, instr}) do
    traverse_1(graph, instr, "AAA")
  end

  defp solve_2({graph, instr}) do
    graph
    |> DirectedGraph.vertices()
    |> Enum.filter(&(String.last(&1) == "A"))
    |> Enum.map(fn node ->
      traverse_2(graph, instr, node)
    end)
    |> lcm()
  end

  defp traverse_1(graph, instr, node, acc \\ 0)
  defp traverse_1(_graph, _instr, "ZZZ", acc), do: acc

  defp traverse_1(graph, instr, node, acc) do
    node =
      Enum.reduce(instr, node, fn direction, current_node ->
        graph
        |> DirectedGraph.out_edges(current_node)
        |> Enum.find(fn {_, edge} -> edge.label == direction end)
        |> then(fn {_, edge} -> edge.v2 end)
      end)

    traverse_1(graph, instr, node, acc + length(instr))
  end

  defp traverse_2(graph, instr, node, acc \\ 0) do
    if String.last(node) == "Z" do
      acc
    else
      node =
        Enum.reduce(instr, node, fn direction, current_node ->
          graph
          |> DirectedGraph.out_edges(current_node)
          |> Enum.find(fn {_, edge} -> edge.label == direction end)
          |> then(fn {_, edge} -> edge.v2 end)
        end)

      traverse_2(graph, instr, node, acc + length(instr))
    end
  end
end
